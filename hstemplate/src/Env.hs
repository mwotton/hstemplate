{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
module Env where

import           Config            (Config (..))
import qualified Honeycomb         as HC
import qualified Honeycomb.Trace   as HC
import           Lens.Micro.Mtl    ()
import           Schema            (DB)
import           Squeal.PostgreSQL (Connection, K, Pool, createConnectionPool)

instance HC.HasHoney Env where
  honeyL = _

instance HC.HasSpanContext Env where
  spanContextL = lens _

buildEnv :: Config -> IO Env
buildEnv Config {..} = do
  connectionPool <- createConnectionPool connstr 1 0.5 20
  pure Env{..}

data Env
  = Env
      { connectionPool :: !(Pool (K Connection DB))
      }
