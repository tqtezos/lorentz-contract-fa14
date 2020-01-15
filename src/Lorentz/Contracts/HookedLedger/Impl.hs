{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE RebindableSyntax #-}

{-# OPTIONS -Wno-unused-do-bind #-}

-- | Implementation of hooked ledger which does not require
-- particular storage type.

module Lorentz.Contracts.HookedLedger.Impl
  ( StorageC

  , transfer
  , approve
  , getAllowance
  , getBalance
  , getTotalSupply
  , setPause
  , setAdministrator
  , getAdministrator
  , mint
  , burn
  , getGranularity
  , getTransferHook

  , creditTo
  , debitFrom
  , authorizeAdmin
  , addTotalSupply
  , allowance
  , setAllowance
  , consumeAllowance
  , ensureNotPaused
  ) where

import Lorentz

import Lorentz.Contracts.HookedLedger.Types

type StorageC store =
  ( LedgerC store
  , StorageContains store
   [ "admin" := Address
   , "paused" := Bool
   , "granularity" := Natural
   ]
  )

type LedgerC store = StorageContains store
  [ "totalSupply" := Natural
  , "ledger" := Address ~> LedgerValue
  ]

----------------------------------------------------------------------------
-- Entrypoints
----------------------------------------------------------------------------

transfer
  :: forall store. (LedgerC store, StoreHasField store "paused" Bool)
  => Entrypoint TransferParams store
transfer = do
  -- doc $ DDescription transferDoc
  dip ensureNotPaused
  dup; getField #to; dip (toField #from)
  stackType @[Address, Address, TransferParams, store]
  if IsEq
    then drop
    else do
      -- Check whether we need to consider allowance
      stackType @[TransferParams, store]
      getField #from
      sender
      stackType @[Address, Address, TransferParams, store]
      -- Consume allowance if necessary
      if IsEq
        then nop
        else dup >> dip @TransferParams consumeAllowance
      -- Perform transfer
      creditTo; debitFrom
      drop @TransferParams
  nil; pair

approve
  :: forall store. (LedgerC store, StoreHasField store "paused" Bool)
  => Entrypoint ApproveParams store
approve = do
  -- doc $ DDescription approveDoc
  sender; toNamed #sender
  approveParamsToAllowanceParams
  dip ensureNotPaused
  duupX @2; duupX @2; allowance
  dup; int
  if IsZero
    then drop
    else do duupX @2; toField #value; int
            ifEq0 drop (failCustom #unsafeAllowanceChange)
  setAllowance; nil; pair

getAllowance
  :: LedgerC store
  => Entrypoint (View GetAllowanceParams Natural) store
getAllowance = do
  -- doc $ DDescription getAllowanceDoc
  view_ (do unpair; allowance)

getBalance :: LedgerC store => Entrypoint (View GetBalanceParams Natural) store
getBalance = view_ $ do
  -- doc $ DDescription getBalanceDoc
  unpair; fromNamed #owner; stGet #ledger
  ifSome (toField #balance) (push 0)

getTotalSupply :: LedgerC store => Entrypoint (View () Natural) store
getTotalSupply = do
  -- doc $ DDescription getTotalSupplyDoc
  view_ (do cdr; stToField #totalSupply)

setPause :: StorageC store => Entrypoint Bool store
setPause = do
  -- doc $ DDescription setPauseDoc
  dip authorizeAdmin
  stSetField #paused
  nil; pair

setAdministrator :: forall store. StorageC store => Entrypoint Address store
setAdministrator = do
  -- doc $ DDescription setAdministratorDoc
  dip authorizeAdmin;
  stackType @[Address, store]
  stSetField #admin
  nil; pair;

getAdministrator :: StorageC store => Entrypoint (View () Address) store
getAdministrator = do
  -- doc $ DDescription getAdministratorDoc
  view_ (do cdr; stToField #admin)

getGranularity :: StorageC store => Entrypoint (View () Natural) store
getGranularity = do
  view_ $ do
    cdr
    stToField #granularity

getTransferHook :: StorageC store => Entrypoint (View Address TransferHook) store
getTransferHook = do
  view_ $ do
    unpair
    stGet #ledger
    ifNone
      none
      (toField #transferHook)

mint :: StorageC store => Entrypoint MintParams store
mint = do
  -- doc $ DDescription mintDoc
  dip authorizeAdmin
  creditTo
  drop @MintParams
  nil; pair

burn :: StorageC store => Entrypoint BurnParams store
burn = do
  -- doc $ DDescription burnDoc
  dip authorizeAdmin
  debitFrom
  drop @BurnParams
  nil; pair

----------------------------------------------------------------------------
-- Helpers
----------------------------------------------------------------------------

authorizeAdmin ::
  StorageC store => store : s :-> store : s
authorizeAdmin = do
  -- doc $ DRequireRole "administrator"
  stGetField #admin; sender; eq
  if_ nop (failCustom_ #senderIsNotAdmin)

addTotalSupply
  :: StoreHasField store "totalSupply" Natural
  => Integer : store : s :-> store : s
addTotalSupply = do
  dip $ stGetField #totalSupply
  add; isNat; ifSome nop (failUnexpected [mt|Negative total supply|])
  stSetField #totalSupply

debitFrom
  :: forall param store.
     ( param `HasFieldsOfType` ["from" := Address, "value" := Natural]
     , LedgerC store
     )
  => '[param, store] :-> '[param, store]
debitFrom = do
    -- Get LedgerValue
    duupX @2; duupX @2; toField #from
    stGet #ledger; ifSome nop $ do
      -- Fail if absent
      stackType @[param, store]
      toField #value; toNamed #required; push 0; toNamed #present
      swap; pair; failCustom #notEnoughBalance
    -- Get balance
    stackType @[LedgerValue, param, store]
    getField #balance
    duupX @3; toField #value
    rsub; isNat
    ifSome nop $ do
      -- Fail if balance is not enough
      stackType @[LedgerValue, param, store]
      toField #balance; toNamed #present
      duupX @2; toField #value; toNamed #required
      pair; failCustom #notEnoughBalance
    -- Update balance, LedgerValue and Storage
    setField #balance;
    duupX @2; dip $ do
      nonEmptyLedgerValue; swap; toField #from
      stUpdate #ledger

    -- Update total supply
    dup; dip $ do toField #value; neg; addTotalSupply

creditTo
  :: ( param `HasFieldsOfType` ["to" := Address, "value" := Natural]
     , LedgerC store
     )
  => '[param, store] :-> '[param, store]
creditTo = do
    -- Get LedgerValue
    duupX @2; duupX @2; toField #to
    stGet #ledger
    if IsSome
      then do -- Get balance
              duupX @2; toField #value; dip (getField #balance)
              add @Natural; setField #balance; some
      else do -- Construct LedgerValue (if not empty)
              getField #value; int
              ifEq0 none $ do
                constructT @LedgerValue
                  ( fieldCtor $ getField #value >> toNamed #balance
                  , fieldCtor $ emptyMap >> toNamed #approvals
                  , fieldCtor $ none >> toNamed #transferHook
                  )
                some
    -- Update LedgerValue and Storage
    swap
    dup; dip $ do toField #to; stUpdate #ledger

    -- Update total supply
    dup; dip $ do toField #value; int; addTotalSupply

emptyLedgerValue :: s :-> LedgerValue : s
emptyLedgerValue =
  constructT @LedgerValue
    ( fieldCtor $ push 0 >> coerceWrap
    , fieldCtor $ emptyMap >> coerceWrap
    , fieldCtor $ none >> coerceWrap
    )

-- | Ensure that given 'LedgerValue' value cannot be safely removed
-- and return it.
nonEmptyLedgerValue :: LedgerValue : s :-> Maybe LedgerValue : s
nonEmptyLedgerValue = do
  getField #balance; int
  if IsNotZero
  then some
  else do
    getField #approvals
    size; int
    if IsNotZero
    then some
    else drop >> none

approveParamsToAllowanceParams ::
  "sender" :! Address : ApproveParams : s :-> AllowanceParams : s
approveParamsToAllowanceParams = do
  -- a hack for performance
  -- can be replaced with 'constructT' call if stops working
  pair; coerce_

allowance
  :: ( param `HasFieldsOfType` ["owner" := Address, "spender" := Address]
     , LedgerC store
     )
  => param ': store ': s :-> Natural ': s
allowance = do
  dup; dip $ do
    toField #owner; stGet #ledger
    ifSome (toField #approvals) emptyMap
  toField #spender; get; ifNone (push 0) nop

setAllowance
  :: forall store s.
     LedgerC store
  => (AllowanceParams ': store ': s) :-> (store ': s)
setAllowance = do
  dip (dup @store); swap;
  dip (getField #owner); swap;
  stGet #ledger; ifNone (emptyLedgerValue >> emptyMap) (getField #approvals);
  stackType @(Map Address Natural : LedgerValue : AllowanceParams : store : _)
  duupX @3; toField #value; nonZero
  duupX @4; toField #spender
  update; setField #approvals
  stackType @(LedgerValue : AllowanceParams : store : _)
  swap
  toField #owner;
  stInsert #ledger

consumeAllowance
  :: forall store s. (LedgerC store)
  => (TransferParams ': store ': s) :-> (store ': s)
consumeAllowance = do
  dup
  -- Get current allowance
  dip $ do
    stackType @(TransferParams ': store ': s)
    dip (dup @store)
    toField #from >> toNamed #owner
    sender >> toNamed #spender
    pair
    allowance
  stackType @(TransferParams : Natural : store : s)
  -- Construct value to be passed to 'setAllowance' and call it.
  constructT @AllowanceParams
    ( fieldCtor $ getField #from >> toNamed #owner
    , fieldCtor $ sender >> toNamed #spender
    , fieldCtor $ do
        getField #value; duupX @3
        sub; isNat;
        if IsSome
          then nop
          else do duupX @2; toNamed #present
                  duupX @2; toField #value; toNamed #required
                  pair; failCustom #notEnoughAllowance
        toNamed #value
    )
  dip $ drop @TransferParams >> drop @Natural
  setAllowance

ensureNotPaused
  :: StoreHasField store "paused" Bool
  => store : s :-> store : s
ensureNotPaused = do
  -- doc $ DTokenNotPausedOnly
  stGetField #paused
  if_ (failCustom_ #tokenOperationsArePaused) nop

