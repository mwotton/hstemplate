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

instance HC.HasSpanContext Env where
  spanContextL = lens appHoneycombSpanContext (\x y -> x { appHoneycombSpanContext = y })


withEnv :: (MonadIO m,MonadUnliftIO m) => Config -> (Env -> m a) -> m a
withEnv Config{..} f = do
  server <- HC.defaultHoneyServerOptions
  -- let honeyRunner
  --       | honeyEnabled = HC.withHoney' server honeyConf
  --       | otherwise = _
  --       -- maybe (\f -> f Nothing)
  --       --   (\hc f -> HC.withHoney' server hc _ ) -- $ \hc -> f (Just hc))
  --       -- honeyConf
  HC.withHoney' server honeyConf $ \appHoneycomb ->
    -- HC.withHoney' server  honeyConf $ \appHoneycomb ->
    bracket (createConnectionPool connstr 1 0.5 20) destroyConnectionPool $ \connectionPool ->
      let appHoneycombSpanContext = Nothing in f (Env {..})



data Env
  = Env
      { connectionPool          :: !(Pool (K Connection DB))
      , appHoneycomb            :: HC.Honey
      , appHoneycombSpanContext :: Maybe HC.SpanContext
      }
