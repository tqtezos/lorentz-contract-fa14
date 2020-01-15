{-# LANGUAGE RebindableSyntax #-}

{-# OPTIONS -Wno-unused-do-bind #-}

-- | Managed ledger which is uncompatible with FA1.2 standard (lacking allowances)
-- and extended with limited administrator functionality.

module Lorentz.Contracts.ManagedLedger.Specialized
  ( Parameter (..)

  , specializedManagedLedgerContract

  , module Lorentz.Contracts.ManagedLedger.Specialized.Types
  ) where

import Lorentz
import Data.Char
import Tezos.Address

import Lorentz.Contracts.ManagedLedger.Specialized.Impl
import Lorentz.Contracts.ManagedLedger.Specialized.Types

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

specializedManagedLedgerContract :: Address -> Contract Parameter Storage
specializedManagedLedgerContract adminAddress = do
  unpair
  entryCase @Parameter (Proxy @PlainEntryPointsKind)
    ( #cTransfer /-> transfer
    , #cGetBalance /-> getBalance
    , #cGetTotalSupply /-> getTotalSupply
    , #cGetAdministrator /-> getAdministrator adminAddress
    , #cMint /-> mint adminAddress
    , #cBurn /-> burn adminAddress
    )

-- | Parse something between the two given `Char`'s
betweenChars :: Char -> Char -> ReadP a -> ReadP a
betweenChars beforeChar afterChar =
  P.char beforeChar `P.between` P.char afterChar

-- | Parse something in parentheses
inParensP :: ReadP a -> ReadP a
inParensP = '(' `betweenChars` ')'

-- | Parse something in double-quotes: @"[something]"@
inQuotesP :: ReadP a -> ReadP a
inQuotesP = '"' `betweenChars` '"'

-- | Attempt to parse with given modifier, otherwise parse without
maybeLiftP :: (ReadP a -> ReadP a) -> ReadP a -> ReadP a
maybeLiftP liftP = liftM2 (<|>) liftP id

-- | Attempt to parse `inParensP`, else parse without
maybeInParensP :: ReadP a -> ReadP a
maybeInParensP = maybeLiftP inParensP

-- | Attempt to parse `inQuotesP`, else parse without
maybeInQuotesP :: ReadP a -> ReadP a
maybeInQuotesP = maybeLiftP inQuotesP

-- | Read an `Address`, inside or outside of @""@'s
readAddressP :: ReadP Address
readAddressP =
      maybeInParensP . maybeInQuotesP $ do
        ensureAddressPrefix >>= \_ ->
          P.munch1 isAlphaNum >>= \addressStr ->
            case parseAddress $ T.pack addressStr of
              Left err -> fail $ show err
              Right address' -> return address'
  where
    ensureAddressPrefix =
      (do {('t':'z':'1':_) <- P.look; return ()}) <|>
      (do {('K':'T':'1':_) <- P.look; return ()})

instance Read Address where
  readPrec = readP_to_Prec $ const readAddressP

instance IsString Address where
  fromString = read

