{-# LANGUAGE RebindableSyntax #-}

{-# OPTIONS_GHC -Wno-orphans #-}
{-# OPTIONS -Wno-unused-do-bind #-}

-- | Types for specialized ManagedLedger.

module Lorentz.Contracts.ManagedLedger.Specialized.Hooked.Types
  ( AL.TransferParams
  , AL.GetBalanceParams
  , ML.MintParams
  , ML.BurnParams
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
import Prelude (Enum(toEnum), sum)
import Data.Functor

import qualified Lorentz.Contracts.Spec.ApprovableLedgerInterface as AL
import qualified Lorentz.Contracts.ManagedLedger.Types as ML
import Util.Named ((.!))

----------------------------------------------------------------------------
-- Parameters
----------------------------------------------------------------------------

-- type MintParams = ("to" :! Address, "value" :! Natural)
-- type BurnParams = ("from" :! Address, "value" :! Natural)

type TransferHookParams = ("isTo" :! Bool, "user" :! Address, "value" :! Natural)

-- type TransferParams = ("from" :! Address, "to" :! Address, "value" :! Natural)
mkTransferHookParams :: Bool -> ML.TransferParams & s :-> TransferHookParams & s
mkTransferHookParams True = do
  coerce_ @ML.TransferParams @(Address, (Address, Natural))
  cdr
  push True
  pair
  coerce_ @(Bool, (Address, Natural)) @TransferHookParams
mkTransferHookParams False = do
  coerce_ @ML.TransferParams @(Address, (Address, Natural))
  unpair
  dip cdr
  pair
  push False
  pair
  coerce_ @(Bool, (Address, Natural)) @TransferHookParams

type TransferHooks = Maybe (Lambda () (ContractRef TransferHookParams))

-- | `TransferHooks` that do nothing
emptyTransferHooks :: TransferHooks
emptyTransferHooks = Nothing
-- do
--   drop @TransferHookParams
--   nil @Operation

sendTransferHookParams :: TransferHooks & TransferHookParams & s :-> Maybe Operation & s
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
     (sa :-> Natural & sb)
  -> (Natural & sa :-> TransferHookParams & Natural & sb)
  -> Address & BigMap Address LedgerValue & sa :-> Maybe Operation & BigMap Address LedgerValue & sb
withUserLedger userMissingUpdate userPresentUpdate = do
  dip dup
  dup
  dip get
  swap
  ifNone
    (do
      dip $ do
        dip userMissingUpdate
        swap
        emptyLedgerValue
        some
      update
      none
    )
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

-- | Create a default storage with ability to set some balances to
-- non-zero values.
mkStorage :: Map Address Natural -> Storage
mkStorage balances = Storage
  { ledger = BigMap $ (\balance' -> (#balance .! balance', #transferHooks .! emptyTransferHooks)) <$> balances
  , totalSupply = sum balances
  }
