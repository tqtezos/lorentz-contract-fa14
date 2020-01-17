{-# LANGUAGE RebindableSyntax #-}

{-# OPTIONS_GHC -Wno-orphans #-}
{-# OPTIONS -Wno-unused-do-bind #-}

-- | Types for specialized ManagedLedger.

module Lorentz.Contracts.ManagedLedger.Specialized.Hooked.Identified.Types
  ( AL.TransferParams
  , AL.GetBalanceParams
  , ML.MintParams
  , ML.BurnParams

  , WithWhichToken(..)
  , assertWhichToken
  , runWithWhichToken

  , TransferHookParams
  , mkTransferHookParams
  , TransferHooks
  , emptyTransferHooks
  , sendTransferHookParams

  , emptyLedgerValue
  , LedgerValue
  , Storage (..)
  , mkStorage
  , toStorage
  , unStorage
  , withUserLedger
  ) where

import Lorentz
import Prelude (Typeable, Enum(toEnum), sum)
import Data.Functor

import Michelson.Text
import qualified Lorentz.Contracts.Spec.ApprovableLedgerInterface as AL
import qualified Lorentz.Contracts.ManagedLedger.Types as ML
import Util.Named ((.!))

----------------------------------------------------------------------------
-- Parameters
----------------------------------------------------------------------------

data WithWhichToken a = WithWhichToken
  { whichToken :: !Address
  , wrappedValue :: !a
  }
  deriving stock Generic
  deriving anyclass IsoValue

instance (Typeable a, TypeHasDoc a) => TypeHasDoc (WithWhichToken a) where
  typeDocMdDescription = "Specify which token the corresponding argument is meant for"
  typeDocMdReference = \_ _ -> "unimplemented: TypeHasDoc (WithWhichToken _) => typeDocMdReference"
  typeDocDependencies p = genericTypeDocDependencies p
  typeDocHaskellRep = haskellRepNoFields $ concreteTypeDocHaskellRep @(WithWhichToken ())
  typeDocMichelsonRep = concreteTypeDocMichelsonRep @(WithWhichToken ())

assertWhichToken :: forall cp s. NiceParameter cp => Address & s :-> s
assertWhichToken = do
  self @cp
  address
  assertEq $ mkMTextUnsafe "whichToken not self"

runWithWhichToken :: forall cp a s. NiceParameter cp => WithWhichToken a & s :-> a & s
runWithWhichToken = do
  coerce_ @(WithWhichToken a) @(Address, a)
  unpair
  assertWhichToken @cp

type TransferHookParams = ("isTo" :! Bool, "user" :! Address, "value" :! Natural)

mkTransferHookParams :: forall cp s. NiceParameter cp => Bool -> AL.TransferParams & s :-> WithWhichToken TransferHookParams & s
mkTransferHookParams True = do
  coerce_ @AL.TransferParams @(Address, (Address, Natural))
  cdr
  push True
  pair
  self @cp
  address
  pair
  coerce_ @(Address, (Bool, (Address, Natural))) @(WithWhichToken TransferHookParams)
mkTransferHookParams False = do
  coerce_ @AL.TransferParams @(Address, (Address, Natural))
  unpair
  dip cdr
  pair
  push False
  pair
  self @cp
  address
  pair
  coerce_ @(Address, (Bool, (Address, Natural))) @(WithWhichToken TransferHookParams)

type TransferHooks = Maybe (Lambda () (ContractRef (WithWhichToken TransferHookParams)))

-- | `TransferHooks` that do nothing
emptyTransferHooks :: TransferHooks
emptyTransferHooks = Nothing

sendTransferHookParams :: TransferHooks & WithWhichToken TransferHookParams & s :-> Maybe Operation & s
sendTransferHookParams = do
  ifNone
    (do
      drop
      none
    )
    (do
      unit
      exec
      swap
      dip $ push (toEnum 0 :: Mutez)
      transferTokens
      some
    )

----------------------------------------------------------------------------
-- Storage
----------------------------------------------------------------------------

-- | A user's balance in number of tokens held
type LedgerValue = ("balance" :! Natural, "transferHooks" :! TransferHooks)

emptyLedgerValue :: Natural & s :-> LedgerValue & s
emptyLedgerValue = do
  dip $ push emptyTransferHooks
  pair
  coerce_

data Storage = Storage
  { ledger :: BigMap Address LedgerValue
  , totalSupply :: Natural
  } deriving stock Generic
    deriving anyclass IsoValue

toStorage :: (BigMap Address LedgerValue, Natural) & s :-> Storage & s
toStorage = coerce_

unStorage :: Storage & s :-> (BigMap Address LedgerValue, Natural) & s
unStorage = coerce_

withUserLedger ::
     Maybe (sa :-> Natural & sb)
  -> (Natural & sa :-> WithWhichToken TransferHookParams & Natural & sb)
  -> Address & BigMap Address LedgerValue & sa :-> Maybe Operation & BigMap Address LedgerValue & sb
withUserLedger userMissingUpdate userPresentUpdate = do
  dip dup
  dup
  dip get
  swap
  ifNone
    noLedgerEntryCase'
    (do
      dup
      dip $ do
        pair
        swap
        dip $ do
          unpair
          swap
          dip $ do
            coerce_ @LedgerValue @(Natural, TransferHooks)
            unpair
            swap
            dip userPresentUpdate
            sendTransferHookParams
            pair
          pair
        swap
        unpair
        swap
        unpair
        dip swap
      swap
      dip $ do
        coerce_ @LedgerValue @(Natural, TransferHooks)
        cdr
        swap
        dip $ do
          swap
          pair
          coerce_ @(Natural, TransferHooks) @LedgerValue
          some
        update
    )
  where
    noLedgerEntryCase' =
      case userMissingUpdate of
        Nothing -> do
          push $ mkMTextUnsafe "sender unknown"
          pair
          failWith
        Just userMissingUpdate' -> do
          dip $ do
            dip userMissingUpdate'
            swap
            emptyLedgerValue
            some
          update
          none


-- | Create a default storage with ability to set some balances to
-- non-zero values.
mkStorage :: Map Address Natural -> Storage
mkStorage balances = Storage
  { ledger = BigMap $ (\balance' -> (#balance .! balance', #transferHooks .! emptyTransferHooks)) <$> balances
  , totalSupply = sum balances
  }
