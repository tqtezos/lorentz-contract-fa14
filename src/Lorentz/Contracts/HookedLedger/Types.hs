{-# OPTIONS_GHC -Wno-orphans #-}

-- | Types shared between contracts participating in HookedLedger.

module Lorentz.Contracts.HookedLedger.Types
  ( AL.TransferParams
  , AL.ApproveParams
  , AL.GetAllowanceParams
  , AL.GetBalanceParams
  , AllowanceParams
  , MintParams
  , BurnParams

  , LedgerValue
  , TransferHook
  , Storage' (..)
  , mkStorage'
  ) where

import Lorentz
import Prelude ((<$>))

import Fmt (Buildable(..))

import qualified Lorentz.Contracts.Spec.ApprovableLedgerInterface as AL
import Util.Named ((.!))

----------------------------------------------------------------------------
-- Parameters
----------------------------------------------------------------------------

type AllowanceParams = ("owner" :! Address, "spender" :! Address, "value" :! Natural)
type MintParams = ("to" :! Address, "value" :! Natural)
type BurnParams = ("from" :! Address, "value" :! Natural)

type TransferHook = Maybe (ContractRef (Bool, Address, Natural)) -- ("isTo" :! Bool, "user" :! Address, "

type LedgerValue = ("balance" :! Natural, "approvals" :! Map Address Natural, "transferHook" :! TransferHook)

----------------------------------------------------------------------------
-- Errors
----------------------------------------------------------------------------

-- | All kinds of transfers are unavailable until resumed by token admin.
type instance ErrorArg "tokenOperationsArePaused" = ()

-- Buildable instances
----------------------------------------------------------------------------

instance Buildable (CustomError "tokenOperationsArePaused") where
  build (CustomError _ ()) =
    "Operations are paused and cannot be invoked"

-- Documentation
----------------------------------------------------------------------------

instance CustomErrorHasDoc "tokenOperationsArePaused" where
  customErrClass = ErrClassActionException
  customErrDocMdCause =
    "Token functionality (`transfer` and similar entrypoints) is suspended."

----------------------------------------------------------------------------
-- Storage
----------------------------------------------------------------------------

data Storage' fields = Storage'
  { ledger :: !(BigMap Address LedgerValue)
  , fields :: !fields
  } deriving stock Generic
    deriving anyclass IsoValue

instance (StoreHasField fields fname ftype, IsoValue fields) =>
         StoreHasField (Storage' fields) fname ftype where
  storeFieldOps = storeFieldOpsDeeper #fields

-- instance (IsoValue fields) =>
--          StoreHasField (Storage' fields) "granularity" Natural where
--   storeFieldOps = storeFieldOpsDeeper #granularity

instance IsoValue fields =>
         StoreHasSubmap (Storage' fields) "ledger" Address LedgerValue where
  storeSubmapOps = storeSubmapOpsDeeper #ledger



-- | Create a default storage with ability to set some balances to
-- non-zero values.
mkStorage' :: Map Address (Natural, TransferHook) -> fields -> Storage' fields
mkStorage' balances flds =
  Storage'
  { ledger = BigMap $ toLedgerValue <$> balances
  , fields = flds
  }
  where
    toLedgerValue (initBal, transferHook') = (#balance .! initBal, #approvals .! mempty, #transferHook .! transferHook')

