{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE TupleSections #-}
{-# OPTIONS_GHC -fno-warn-partial-type-signatures #-}

module DBHelpers where
import           Control.Exception         (throwIO)
--import           Data.Pool
import Squeal.PostgreSQL.Session.Pool
import           Database.Postgres.Temp    (cacheAction, cacheConfig, DB,
                                            verboseConfig, postgresConfigFile, defaultConfig,
                                            withConfig, withDbCache, toConnectionOptions)
import System.Directory
import System.Process
import System.Exit(ExitCode(..))
import Database.PostgreSQL.Simple.Options(Options(..),host,  toConnectionString)
import Data.Maybe(fromJust)
import Debug.Pretty.Simple
import qualified Data.ByteString.Char8 as BS8
import Env(Env(..))
import qualified Honeycomb as HC

import Squeal.PostgreSQL.Session.Connection

withEnv :: (Env -> IO ()) -> IO ()
withEnv f = HC.withHoney $ \hc ->
  withSetup $ \pool -> do
    f $ Env pool hc Nothing -- (error "hc") (error "hc")



withSetup :: (Pool (K Connection _) -> IO ()) -> IO ()
withSetup f = do
  -- Helper to throw exceptions
  let throwE x = either throwIO pure =<< x

  throwE $ withDbCache $ \dbCache -> do

    let combinedConfig = defaultConfig <> cacheConfig dbCache
        --combinedConfig = combinedConfig' { postgresConfigFile = ("log_statement", "all") :postgresConfigFile combinedConfig' }
    Just hash <- viaNonEmpty last . lines . toText <$> do
      putStrLn "plan called"
      (errCode, out, err) <- readCreateProcessWithExitCode (shell "cd ..; sqitch plan -f format:%h") ""
      if errCode == ExitSuccess
        then pure out
        else do
          dir <- getCurrentDirectory
          error (toText $ unlines ["err",toText err,"out",toText out, "dir", toText dir])
    setCurrentDirectory ".."
    let migrate connstr = putStrLn "migration called" >> print connstr >> callProcess "sqitch" ["deploy","-t", "db:pg:" <> BS8.unpack connstr]
    Right migratedConfig <- cacheAction ("~/.tmp-postgres/" <> toString hash)
                     (migrate . dbiConnString . toConnectionOptions  <=< dumpInfo ) combinedConfig

    withConfig migratedConfig $ \db -> do
      print ("conninfo", toConnectionString $ toConnectionOptions db)
      f =<< createConnectionPool (toConnectionString . toConnectionOptions $ db) 2 60 10

dumpInfo :: DB -> IO DB
dumpInfo db = do
  pTraceShowM (toConnectionOptions db)
  pure db

-- | Make a dbi-compatible key value postgresql option string, the worst possible way.
dbiConnString :: Options -> ByteString
dbiConnString =  ("/?" <>) . BS8.map toAmpersands . toConnectionString
  where toAmpersands ' ' = '&'
        toAmpersands x = x

-- abort :: (Connection -> IO a) -> Connection -> IO a
-- abort f conn = bracket_
--   (execute_ conn "BEGIN")
--   (execute_ conn "ROLLBACK")
--   (f conn)
