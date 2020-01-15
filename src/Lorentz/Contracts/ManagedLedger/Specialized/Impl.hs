{-# LANGUAGE RebindableSyntax #-}

{-# OPTIONS -Wno-unused-do-bind #-}

-- | Implementation of specialized managed ledger which inlines
-- admin `Address`, lacks allowances, and cannot be paused.

module Lorentz.Contracts.ManagedLedger.Specialized.Impl
  ( transfer
  , getBalance
  , getTotalSupply
  , getAdministrator
  , mint
  , burn

  , creditTo
  , debitFrom
  , authorizeAdmin
  , addTotalSupply
  ) where

import Prelude hiding ((>>), drop, swap, get, some)

import Lorentz
-- import Tezos.Address
-- import GHC.Natural
import Michelson.Text

import Lorentz.Contracts.ManagedLedger.Specialized.Types

----------------------------------------------------------------------------
-- Entrypoints
----------------------------------------------------------------------------

transfer :: Entrypoint TransferParams Storage
transfer = do
  coerce_ @TransferParams @(Address, (Address, Natural))
  -- dup; getField #to; dip (toField #from)
  -- dup; getField #to; dip (toField #from)
  -- stackType @[Address, Address, TransferParams, Storage]
  -- if IsEq
  --   then drop
  --   else do
  --     coerce_ @TransferParams @(Address, (Address, Natural))
  unpair
  dip $ do
    dip $ coerce_ @Storage @(BigMap Address LedgerValue, Natural)
    unpair
    swap
    dip $ do
      dip $ do
        unpair
        dup
      dup
      dip $ do
        get
        ifSome nop $ push 0
        -- [to_balance, total_supply, ledger]
      -- [to_address, to_balance, total_supply, ledger]
    -- [amount_transferred, to_address, to_balance, total_supply, ledger]
    dup
    dip $ do
      swap
      dip $ do
        add
        some
      update
  -- [from_address, amount_transferred, ledger, totalSupply]
  swap
  dip $ do
  -- [amount_transferred, from_address, ledger, totalSupply]
    dip dup
    dup
    dip $ do
      get
      ifSome nop $ do
        push $ mkMTextUnsafe "from missing"
        failWith
    -- [from_balance, from_address, ledger, ..]
    swap
  -- [amount_transferred, from_balance, from_address, ledger, ..]
  rsub >> isNat
  ifSome some $ do
    push $ mkMTextUnsafe "insufficient balance"
    failWith
  swap
  update
  pair
  coerce_ @(BigMap Address LedgerValue, Natural) @Storage
  nil; pair


getBalance :: Entrypoint (View GetBalanceParams Natural) Storage
getBalance = view_ $ do
  unpair; fromNamed #owner; dip (toField #ledger); get
  ifSome nop (push 0)

getTotalSupply :: Entrypoint (View () Natural) Storage
getTotalSupply = do
  view_ (do cdr; toField #totalSupply)

getAdministrator :: Address -> Entrypoint (View () Address) store
getAdministrator adminAddress = do
  view_ (drop >> push adminAddress)

mint :: Address -> Entrypoint MintParams Storage
mint adminAddress = do
  authorizeAdmin adminAddress
  creditTo
  drop @MintParams
  nil; pair

burn :: Address -> Entrypoint BurnParams Storage
burn adminAddress = do
  authorizeAdmin adminAddress
  debitFrom
  drop @BurnParams
  nil; pair

----------------------------------------------------------------------------
-- Helpers
----------------------------------------------------------------------------

authorizeAdmin :: Address
               -> s :-> s
authorizeAdmin adminAddress = do
  push adminAddress
  sender; eq
  if_ nop (failCustom_ #senderIsNotAdmin)

addTotalSupply
  :: Integer : Storage : s :-> Storage : s
addTotalSupply = do
  dip $ getField #totalSupply
  add; isNat; ifSome nop (failUnexpected [mt|Negative total supply|])
  setField #totalSupply

debitFrom
  :: forall param.
     ( KnownValue param
     , param `HasFieldsOfType` ["from" := Address, "value" := Natural]
     )
  => '[param, Storage] :-> '[param, Storage]
debitFrom = do
    -- Get LedgerValue
    duupX @2; duupX @2; toField #from
    dip $ toField #ledger
    get

    ifSome nop $ do
      -- Fail if absent
      stackType @[param, Storage]
      toField #value; toNamed #required; push 0; toNamed #present
      swap; pair; failCustom #notEnoughBalance
    -- Get balance
    stackType @[LedgerValue, param, Storage]
    dup
    dip $ swap >> getField #value
    sub @Natural @Natural; isNat
    dip swap
    ifSome (dip drop) $ do
      -- Fail since balance is not enough
      stackType @[LedgerValue, param, Storage]
      pair
      push @MText $ mkMTextUnsafe "insufficient balance"
      pair
      failWith
    -- Update balance, LedgerValue and Storage
    duupX @2; dip $ do
      nonEmptyLedgerValue; swap; toField #from
      dip $ dip $ do
        coerce_ @Storage @(BigMap Address LedgerValue, Natural)
        unpair
      update
      pair
      coerce_ @(BigMap Address LedgerValue, Natural) @Storage

    -- Update total supply
    dup; dip $ do toField #value; neg; addTotalSupply

creditTo
  :: ( param `HasFieldsOfType` ["to" := Address, "value" := Natural]
     )
  => '[param, Storage] :-> '[param, Storage]
creditTo = do
    -- Get LedgerValue
    duupX @2; duupX @2; toField #to
    dip $ toField #ledger
    get
    if IsSome
       then do
         duupX @2; toField #value;
         add @Natural; some
       else do
         getField #value; int;
         ifEq0 none (getField #value >> some)

    swap
    dup;
    dip $ do
      toField #to
      dip $ dip $ do
        coerce_ @Storage @(BigMap Address LedgerValue, Natural)
        unpair
      update
      pair
      coerce_ @(BigMap Address LedgerValue, Natural) @Storage

    -- Update total supply
    dup; dip $ do toField #value; int; addTotalSupply

-- | Ensure that given 'LedgerValue' value cannot be safely removed
-- and return it.
nonEmptyLedgerValue :: LedgerValue : s :-> Maybe LedgerValue : s
nonEmptyLedgerValue = do
  dup
  int
  if IsNotZero
  then some
  else drop >> none

