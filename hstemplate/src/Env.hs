{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
module Env where

import           Config            (Config (..))
import qualified Honeycomb         as HC
import qualified Honeycomb.Trace   as HC
import           Lens.Micro        (lens)
import           Schema            (DB)
import           Squeal.PostgreSQL (Connection, K, Pool, createConnectionPool,
                                    destroyConnectionPool)
import           UnliftIO

instance HC.HasHoney Env where
  honeyL = lens appHoneycomb (\x y -> x { appHoneycomb = y })

-- instance HC.HasSpanContext Env where
--   spanContextL = lens _ _

withEnv :: (MonadIO m,MonadUnliftIO m) => Config -> (Env -> m a) -> m a
withEnv Config{..} f = do
  server <- HC.defaultHoneyServerOptions
  HC.withHoney' server  honeyConf $ \appHoneycomb ->
    bracket (createConnectionPool connstr 1 0.5 20) destroyConnectionPool $ \connectionPool ->
      f (Env {..})



data Env
  = Env
      { connectionPool :: !(Pool (K Connection DB))
      , appHoneycomb   :: !HC.Honey
      }
