{-# LANGUAGE OverloadedStrings #-}

module DBHelpers where
import           Control.Exception         (throwIO)
import           Data.Pool
import           Database.Postgres.Temp    (cacheAction, cacheConfig, DB,
                                            defaultConfig,
                                            withConfig, withDbCache, toConnectionOptions)
import           Database.PostgreSQL.LibPQ (finish, connectdb, Connection)
import System.Process
import Database.PostgreSQL.Simple.Options(Options(..),host,  toConnectionString)
import Data.Maybe(fromJust)
import Debug.Pretty.Simple
import qualified Data.ByteString.Char8 as BS8

withSetup :: (Connection -> IO ()) -> IO ()
withSetup f = do
  -- Helper to throw exceptions
  let throwE x = either throwIO pure =<< x

  throwE $ withDbCache $ \dbCache -> do

    let combinedConfig = defaultConfig <> cacheConfig dbCache
    Just hash <- viaNonEmpty last . lines . toText <$> do
      putStrLn "plan called"
      readCreateProcess (shell "sqitch plan -f format:%h") ""
    print hash
    let migrate connstr = putStrLn "migration called" >> print connstr >> callProcess "sqitch" ["deploy","-t", "db:pg:" <> BS8.unpack connstr]
    Right migratedConfig <- cacheAction ("~/.tmp-postgres/" <> toString hash)
                     (migrate . dbiConnString . toConnectionOptions  <=< dumpInfo ) combinedConfig
    withConfig migratedConfig $ \db -> do
      pool <- createPool (connectdb . dbiConnString . toConnectionOptions $ db) finish 2 60 10
      withResource pool f

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