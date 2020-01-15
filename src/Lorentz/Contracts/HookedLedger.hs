{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE RebindableSyntax #-}

{-# OPTIONS -Wno-unused-do-bind #-}

-- | Hooked ledger which is compatible with FA1.2 standard and
-- extended with administrator functionality.

module Lorentz.Contracts.HookedLedger
  ( Parameter (..)

  , Storage
  , mkStorage
  , managedLedgerContract

  , module Lorentz.Contracts.HookedLedger.Types
  ) where

import Lorentz
import Prelude ((<$>), sum, fst)

import Lorentz.Contracts.HookedLedger.Types
import Lorentz.Contracts.HookedLedger.Impl

{-# ANN module ("HLint: ignore Reduce duplication" :: Text) #-}

----------------------------------------------------------------------------
-- Parameter
----------------------------------------------------------------------------

data Parameter
  = Transfer         !TransferParams
  | Approve          !ApproveParams
  | GetAllowance     !(View GetAllowanceParams Natural)
  | GetBalance       !(View GetBalanceParams Natural)
  | GetTotalSupply   !(View () Natural)
  | SetPause         !Bool
  | SetAdministrator !Address
  | GetAdministrator !(View () Address)
  | Mint             !MintParams
  | Burn             !BurnParams
  | GetGranularity   !(View () Natural)
  | GetTransferHook  !(View Address TransferHook)
  deriving stock Generic
  deriving anyclass IsoValue

instance ParameterEntryPoints Parameter where
  parameterEntryPoints = pepPlain

----------------------------------------------------------------------------
-- Storage
----------------------------------------------------------------------------

data StorageFields = StorageFields
  { admin       :: !Address
  , paused      :: !Bool
  , granularity :: !Natural
  , totalSupply :: !Natural
  } deriving stock Generic
    deriving anyclass IsoValue

instance HasFieldOfType StorageFields name field =>
         StoreHasField StorageFields name field where
  storeFieldOps = storeFieldOpsADT

type Storage = Storage' StorageFields

-- | Create a default storage with ability to set some balances to
-- non-zero values.
mkStorage :: Natural -> Address -> Map Address (Natural, TransferHook) -> Storage
mkStorage granularity' adminAddress balances = mkStorage' balances $
  StorageFields
  { admin = adminAddress
  , paused = False
  , granularity = granularity'
  , totalSupply = sum $ fst <$> balances
  }

----------------------------------------------------------------------------
-- Implementation
----------------------------------------------------------------------------

managedLedgerContract :: Contract Parameter Storage
managedLedgerContract = contractName "Hooked Ledger" $ do
  -- doc $ $mkDGitRevision morleyRepoSettings
  -- doc $ DDescription contractDoc
  unpair
  entryCase @Parameter (Proxy @PlainEntryPointsKind)
    ( #cTransfer /-> transfer
    , #cApprove /-> approve
    , #cGetAllowance /-> getAllowance
    , #cGetBalance /-> getBalance
    , #cGetTotalSupply /-> getTotalSupply
    , #cSetPause /-> setPause
    , #cSetAdministrator /-> setAdministrator
    , #cGetAdministrator /-> getAdministrator
    , #cMint /-> mint
    , #cBurn /-> burn
    , #cGetGranularity /-> getGranularity
          -- _ -- _ :: '[View () Natural, Storage] :-> '[([Operation], Storage)]
    , #cGetTransferHook /->  getTransferHook
          -- _ -- '[View Address TransferHook, Storage] :-> '[([Operation], Storage)]
    )

--   | GetGranularity   !(View () Natural)
--   | GetTransferHook  !(View Address TransferHook)

