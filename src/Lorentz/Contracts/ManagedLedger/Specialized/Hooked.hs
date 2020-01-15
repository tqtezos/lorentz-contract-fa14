{-# LANGUAGE RebindableSyntax #-}

{-# OPTIONS -Wno-unused-do-bind #-}

-- | Managed ledger which is uncompatible with FA1.2 standard (lacking allowances)
-- and extended with limited administrator functionality.

module Lorentz.Contracts.ManagedLedger.Specialized.Hooked
  ( Parameter (..)

  , hookedSpecializedManagedLedgerContract

  , module Lorentz.Contracts.ManagedLedger.Specialized.Hooked.Types
  ) where

import Lorentz
import Data.Char
import Tezos.Address

import Lorentz.Contracts.ManagedLedger.Specialized.Hooked.Impl
import Lorentz.Contracts.ManagedLedger.Specialized.Hooked.Types

import Data.Function
import Data.String
import Control.Applicative
import Control.Monad (Monad((>>=)), liftM2)
import Control.Monad.Fail
import Text.ParserCombinators.ReadP (ReadP)
import Text.Read
import Text.Show
import qualified Data.Text as T
import qualified Text.ParserCombinators.ReadP as P

{-# ANN module ("HLint: ignore Reduce duplication" :: Text) #-}

----------------------------------------------------------------------------
-- Parameter
----------------------------------------------------------------------------

data Parameter
  = Transfer         !TransferParams
  | SetHooks         !TransferHooks
  | GetHooks         !(View Address TransferHooks)
  | GetBalance       !(View GetBalanceParams Natural)
  | GetTotalSupply   !(View () Natural)
  | GetAdministrator !(View () Address)
  | Mint             !MintParams
  | Burn             !BurnParams
  deriving stock Generic
  deriving anyclass IsoValue

instance ParameterEntryPoints Parameter where
  parameterEntryPoints = pepPlain

----------------------------------------------------------------------------
-- Implementation
----------------------------------------------------------------------------

hookedSpecializedManagedLedgerContract :: Address -> Contract Parameter Storage
hookedSpecializedManagedLedgerContract adminAddress = do
  unpair
  entryCase @Parameter (Proxy @PlainEntryPointsKind)
    ( #cTransfer /-> transfer
    , #cSetHooks /-> setHooks
    , #cGetHooks /-> getHooks
    , #cGetBalance /-> getBalance
    , #cGetTotalSupply /-> getTotalSupply
    , #cGetAdministrator /-> getAdministrator adminAddress
    , #cMint /-> mint adminAddress
    , #cBurn /-> burn adminAddress
    )

