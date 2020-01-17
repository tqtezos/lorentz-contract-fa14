{-# LANGUAGE RebindableSyntax #-}

{-# OPTIONS -Wno-unused-do-bind #-}

-- | Managed ledger which is uncompatible with FA1.2 standard (lacking allowances)
-- and extended with limited administrator functionality.

module Lorentz.Contracts.ManagedLedger.Specialized.Hooked.Identified
  ( Parameter (..)

  , hookedSpecializedManagedLedgerContract

  , module Lorentz.Contracts.ManagedLedger.Specialized.Hooked.Identified.Types
  ) where

import Lorentz
import Data.Char
import Tezos.Address

import Lorentz.Contracts.ManagedLedger.Specialized.Hooked.Identified.Impl
import Lorentz.Contracts.ManagedLedger.Specialized.Hooked.Identified.Types

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
  = Transfer         !(WithWhichToken TransferParams)
  | SetHooks         !TransferHooks
  | GetHooks         !(View Address TransferHooks)
  | GetBalance       !(View (WithWhichToken GetBalanceParams) Natural)
  | GetTotalSupply   !(View ("whichToken" :! Address) Natural)
  | GetGranularity   !(View ("whichToken" :! Address) Natural)
  | GetAdministrator !(View () Address)
  | Mint             !(WithWhichToken MintParams)
  | Burn             !(WithWhichToken BurnParams)
  deriving stock Generic
  deriving anyclass IsoValue

instance ParameterEntryPoints Parameter where
  parameterEntryPoints = pepPlain

----------------------------------------------------------------------------
-- Implementation
----------------------------------------------------------------------------

hookedSpecializedManagedLedgerContract :: Natural -> Address -> Contract Parameter Storage
hookedSpecializedManagedLedgerContract granularity adminAddress = do
  unpair
  entryCase @Parameter (Proxy @PlainEntryPointsKind)
    ( #cTransfer /-> transfer @Parameter
    , #cSetHooks /-> setHooks
    , #cGetHooks /-> getHooks
    , #cGetBalance /-> getBalance @Parameter
    , #cGetTotalSupply /-> getTotalSupply @Parameter
    , #cGetGranularity /-> getGranularity @Parameter granularity
    , #cGetAdministrator /-> getAdministrator adminAddress
    , #cMint /-> mint @Parameter adminAddress
    , #cBurn /-> burn @Parameter adminAddress
    )

