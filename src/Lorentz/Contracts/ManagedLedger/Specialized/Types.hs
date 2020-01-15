{-# OPTIONS_GHC -Wno-orphans #-}

-- | Types for specialized ManagedLedger.

module Lorentz.Contracts.ManagedLedger.Specialized.Types
  ( AL.TransferParams
  , AL.GetBalanceParams
  , ML.MintParams
  , ML.BurnParams

  , LedgerValue
  , Storage (..)
  , mkStorage
  ) where

import Lorentz

import qualified Lorentz.Contracts.Spec.ApprovableLedgerInterface as AL
import qualified Lorentz.Contracts.ManagedLedger.Types as ML
import Util.Named ((.!))

----------------------------------------------------------------------------
-- Parameters
----------------------------------------------------------------------------

-- type MintParams = ("to" :! Address, "value" :! Natural)
-- type BurnParams = ("from" :! Address, "value" :! Natural)

----------------------------------------------------------------------------
-- Storage
----------------------------------------------------------------------------

-- | A user's balance in number of tokens held
type LedgerValue = Natural

data Storage = Storage
  { ledger :: BigMap Address LedgerValue
  , totalSupply :: Natural
  } deriving stock Generic
    deriving anyclass IsoValue

-- | Create a default storage with ability to set some balances to
-- non-zero values.
mkStorage :: Map Address LedgerValue -> Storage
mkStorage balances = Storage
  { ledger = BigMap balances
  , totalSupply = sum balances
  }
