{-# LANGUAGE RebindableSyntax #-}
-- {-# LANGUAGE DuplicateRecordFields #-}

{-# OPTIONS -Wno-missing-export-lists -Wno-unused-do-bind -Wno-partial-fields -Wno-orphans #-}


module Lorentz.Contracts.Receiver where

import Lorentz

-- import Text.Read
import Text.Show

data Parameter cp
  = Register !()
  | UnRegister !()
  | IsRegistered (View Address Bool)
  | WrappedParameter !cp
  deriving  (Generic)

instance NiceParameter a => ParameterEntryPoints (Parameter a) where
  parameterEntryPoints = pepNone

-- deriving instance (NiceParameter a, Read a) => Read (Parameter a)

deriving instance Show a => Show (Parameter a)

deriving instance IsoValue a => IsoValue (Parameter a)

type AddressSet = BigMap Address ()

data Storage st = Storage
  { registeredUsers :: !AddressSet
  , wrappedStorage  :: !st
  }
  deriving  (Generic)

deriving instance Show a => Show (Storage a)

deriving instance (Ord a, IsoValue a, IsoCValue a) => IsoValue (Storage a)

-- | Wrap `Storage` with `pair`ing
mkStorage :: AddressSet & a & s :-> Storage a & s
mkStorage = do
  pair
  coerce_

-- | Unwrap `Storage`
unStorage :: Storage a & s :-> (AddressSet, a) & s
unStorage = coerce_

-- | Wrap `Storage`
toStorage :: (AddressSet, a) & s :-> Storage a & s
toStorage = coerce_


-- hasReceiverContract :: (forall s. cp & s :-> Maybe Address & s) -> Contract cp st -> Contract (Parameter cp) (Storage st)
-- hasReceiverContract getAddress wrappedContract = do
--   unpair
--   caseT @(Parameter a)
--     ( #cAssertTransfer /-> assertTransfer
--     , #cOtherParameter /->

--   unpair

--   caseT @(Parameter cp) (....)

--   dup
--   getAddress
--   ifNone
--     nop
--     (do
--       stMem #registeredUsers
--         -- :: StoreHasSubmap store mname key value
--         -- => Label mname -> key : store : s :-> Bool : s
--       if_
--         (do
--           contract @i
--           assertSome $ mkMTextUnsafe "expected registered user or receiver contract"
--           _
--           transferTokens
--         )
--         nop
--     )
--   _

-- class (StoreHasSubmap store subMapName Address val, StoreHasField val balanceName bal, KnownValue bal, CompareOpHs bal) => StoreHasBalance store subMapName balanceName val bal where
--   newUser :: Address & store & s :-> val & s

-- - lookup address in map
-- - if found, return result
-- - otherwise
--   * if contract, send check to it & add zero balance
--   * if not contract, fail

-- -- | return value found in BigMap
-- Address & store & s :-> val & s

-- Address & store & s :-> s


-- ContractRef i

-- assertReceiverContract :: StoreHasSubmap st name Address (Bool) => (st & s :-> i & s) -> ContractRef i & st & s :-> Operation & st & s
-- assertReceiverContract isReceiverParam = do
--   dip $ do
--     dup
--     isReceiverParam
--   swap
--   dip $ push (toEnum 0 :: Mutez)
--   transferTokens

-- assertReceiverAddress :: StoreHasSubmap st name Address val => Address & st & s :-> val & st & s
-- assertReceiverAddress = do
--   pair
--   dup
--   dip $ do
--     unpair
--     stGet label
--     -- :: StoreHasSubmap store mname key value
--     -- => Label mname -> key : store : s :-> Maybe value : s
--     assertSome $ mkMTextUnsafe "not registered"
--   swap

-- assertReceiver :: StoreHasSubmap st name Address (Bool) => (st & s :-> i & s) -> Address & st & s :-> st & s
-- assertReceiver isReceiverParam = do
--   _lookupAddress
--   ifFound
--     then done
--     else if contract
--     then assertReceiverContract >> done
--     else fail
--   dup
--   dip $ do
--     contract @i
--     ifNone
--       (do
--         assertReceiverAddress
--         _
--       )
--       (do
--         dup
--         isReceiverParam
--         _
--         _


-- -- | Provides operations on fields for storage.
-- class StoreHasSubmap store mname key value | store mname -> key value where
--   storeSubmapOps :: StoreSubmapOps store mname key value

