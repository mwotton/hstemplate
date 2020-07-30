module DBHelpers where
import           Control.Exception         (throwIO)
import           Data.Pool
import           Database.Postgres.Temp    (cacheAction, cacheConfig,
                                            defaultConfig, toConnectionString,
                                            withConfig, withDbCache)
import           Database.PostgreSQL.LibPQ (Connection)

withSetup :: (ByteString -> IO ()) -> (Pool Connection -> IO ()) -> IO ()
withSetup migrate f = do
  -- Helper to throw exceptions
  let throwE x = either throwIO pure =<< x

  throwE $ withDbCache $ \dbCache -> do
    let combinedConfig = defaultConfig <> cacheConfig dbCache
    migratedConfig <- throwE $ cacheAction ("~/.tmp-postgres/" <> hash)
                     (migrate . toConnectionString) combinedConfig
    withConfig migratedConfig $ \db ->
      f =<< createPool (connectPostgreSQL $ toConnectionString db) close 2 60 10
