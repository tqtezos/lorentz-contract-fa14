{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NoImplicitPrelude #-}

{-# OPTIONS -Wno-partial-fields -Wno-orphans -Wno-missing-export-lists #-}

module Main where

import Control.Applicative
import Control.Monad hiding (fail)
import Data.Function
import System.IO
import Prelude (die, displayException, catchAny)

import Lorentz
import Michelson.Typed.Scope
import Util.IO
import Michelson.Printer

import qualified Options.Applicative as Opt
import qualified Data.Text.Lazy as TL
import Data.Singletons
import Text.PrettyPrint.ANSI.Leijen.Internal (Doc, linebreak)

-- import qualified Lorentz.Contracts.Whitelist.CmdLnArgs as WhitelistCmdLnArgs
-- import qualified Lorentz.Contracts.Whitelist.Wrapper.ManagedLedger.CmdLnArgs as WhitelistManagedLedgerCmdLnArgs

-- | Convert to a `Value`, untype, and render
showValue :: (IsoValue t, SingI (ToT t), HasNoOp (ToT t)) => t -> TL.Text
showValue = printTypedValue False . toVal

data CmdLnArgs
  -- = WhitelistCmdLnArgs { whitelistCmdLnArgs :: WhitelistCmdLnArgs.CmdLnArgs }
  -- | WhitelistManagedLedgerCmdLnArgs { whitelistManagedLedgerCmdLnArgs :: WhitelistManagedLedgerCmdLnArgs.CmdLnArgs }

argParser :: Opt.Parser CmdLnArgs
argParser = Opt.hsubparser $ mconcat []
  -- [ Opt.command "Whitelist" $ fmap WhitelistCmdLnArgs $ Opt.info WhitelistCmdLnArgs.argParser WhitelistCmdLnArgs.infoMod
  -- , Opt.command "WhitelistManagedLedger" $ fmap WhitelistManagedLedgerCmdLnArgs $ Opt.info WhitelistManagedLedgerCmdLnArgs.argParser WhitelistManagedLedgerCmdLnArgs.infoMod
  -- ]
  where

programInfo :: Opt.ParserInfo CmdLnArgs
programInfo =
  -- Opt.info (Opt.helper <*> versionOption <*> argParser) $
  Opt.info (Opt.helper <*> argParser) $
  mconcat
    [ Opt.fullDesc
    , Opt.progDesc "FA1.4 parameter generation helper"
    , Opt.header "Lorentz tools"
    , Opt.footerDoc usageDoc
    ]
  -- where
  --   versionOption =
  --     Opt.infoOption
  --       ("lorentz-contract-oracle-" <> versionStr)
  --       (Opt.long "version" <> Opt.help "Show version.")
  --   versionStr = "0.1.0.0" -- showVersion version

usageDoc :: Maybe Doc
usageDoc =
  Just $
  mconcat
    [ "You can use help for specific COMMAND"
    , linebreak
    , "EXAMPLE:"
    , linebreak
    , "  lorentz-contract-fa14 COMMAND --help"
    , linebreak
    ]

main :: IO ()
main = do
  hSetTranslit stdout
  hSetTranslit stderr

  cmdLnArgs <- Opt.execParser programInfo
  run cmdLnArgs `catchAny` (die . displayException)
  where
    run :: CmdLnArgs -> IO ()
    run =
      \case
        -- WhitelistCmdLnArgs {..} ->
        --   WhitelistCmdLnArgs.runCmdLnArgs whitelistCmdLnArgs
        -- WhitelistManagedLedgerCmdLnArgs {..} ->
        --   WhitelistManagedLedgerCmdLnArgs.runCmdLnArgs whitelistManagedLedgerCmdLnArgs

