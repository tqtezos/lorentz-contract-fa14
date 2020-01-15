{-# LANGUAGE RebindableSyntax #-}

{-# OPTIONS -Wno-unused-do-bind #-}

-- | Implementation of specialized managed ledger which inlines
-- admin `Address`, lacks allowances, and cannot be paused.

module Lorentz.Contracts.ManagedLedger.Specialized.Hooked.Impl
  ( transfer
  , setHooks
  , getHooks
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
import Util.Named

import Lorentz.Contracts.ManagedLedger.Specialized.Hooked.Types

----------------------------------------------------------------------------
-- Entrypoints
----------------------------------------------------------------------------

listFromMaybe2 :: KnownValue a => Maybe a & Maybe a & s :-> [a] & s
listFromMaybe2 = do
  ifNone
    (do
      ifNone
        nil
        (do
          dip nil
          cons
        )
    )
    (do
      dip nil
      cons
      swap
      ifNone
        nop
        cons
    )


-- type TransferParams = ("from" :! Address, "to" :! Address, "value" :! Natural)
transfer :: Entrypoint TransferParams Storage
transfer = do
  dip $ do
    coerce_ @Storage @(BigMap Address LedgerValue, Natural)
    unpair
  dup
  dip $ do
    coerce_ @TransferParams @(Address, (Address, Natural))
    cdr
    car
  swap
  dip swap
  withUserLedger (push 0) $ do
    swap
    dup
    mkTransferHookParams transferHookIsTo
    dip $ do
      dup
      dip $ do
        coerce_ @TransferParams @(Address, (Address, Natural))
        cdr
        cdr
        add
      swap
  dip $ do
    dip dup
    swap
    coerce_ @TransferParams @(Address, (Address, Natural))
    car
    withUserLedger
      (do
        push $ mkMTextUnsafe "sender unknown"
        pair
        failWith
      ) $ do
        swap
        dup
        mkTransferHookParams transferHookIsFrom
        dip $ do
          coerce_ @TransferParams @(Address, (Address, Natural))
          cdr
          cdr
          rsub >> isNat
          ifNone
            (do
              push $ mkMTextUnsafe "insufficient balance"
              pair
              failWith
            )
            nop
  listFromMaybe2
  dip $ do
    pair
    coerce_ @(BigMap Address LedgerValue, Natural)
  pair
  where
    transferHookIsTo = True
    transferHookIsFrom = False

setHooks :: Entrypoint TransferHooks Storage
setHooks = do
  dip $ do
    coerce_ @Storage @(BigMap Address LedgerValue, Natural)
    unpair
    dup
    sender
    get -- @(BigMap Address LedgerValue)
    ifNone
      (do
        push @Natural 0
      )
      (do
        coerce_ @LedgerValue @(Natural, TransferHooks)
        car
      )
  swap
  pair
  coerce_ @(Natural, TransferHooks) @LedgerValue
  some
  sender
  update
  pair
  coerce_ @(BigMap Address LedgerValue, Natural) @Storage
  nil
  pair

getHooks :: Entrypoint (View Address TransferHooks) Storage
getHooks = view_ $ do
  unpair; dip (toField #ledger); get
  ifSome (toField #transferHooks) $ push emptyTransferHooks

getBalance :: Entrypoint (View GetBalanceParams Natural) Storage
getBalance = view_ $ do
  unpair; fromNamed #owner; dip (toField #ledger); get
  ifNone (push 0) $ do
    coerce_ @LedgerValue @(Natural, TransferHooks)
    car

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
    coerce_ @LedgerValue @(Natural, TransferHooks)
    unpair
    dip swap
    stackType @[Natural, param, TransferHooks, Storage]
    dup
    dip $ swap >> getField #value
    sub @Natural @Natural; isNat
    dip swap
    -- dip swap
    -- sub @Natural @Natural; isNat
    ifSome (dip drop) $
      do
      -- Fail since balance is not enough
      -- stackType @[LedgerValue, param, Storage]
      -- pair
      -- pair
      push @MText $ mkMTextUnsafe "insufficient balance"
      pair
      failWith
    -- Update balance, LedgerValue and Storage
    duupX @2; dip $ do
      dip swap
      pair
      coerce_ @(Natural, TransferHooks) @LedgerValue
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
         dip $ do
           coerce_ @LedgerValue @(Natural, TransferHooks)
           unpair
         add @Natural
         pair
         coerce_ @(Natural, TransferHooks) @LedgerValue
         some
       else do
         getField #value; int;
         ifEq0 none $ do
           getField #value
           dip $ push emptyTransferHooks
           pair
           coerce_ @(Natural, TransferHooks) @LedgerValue
           some

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
  toField #balance
  int
  if IsNotZero
  then some
  else drop >> none

