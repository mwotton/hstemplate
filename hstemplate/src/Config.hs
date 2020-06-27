{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE RecordWildCards     #-}
{-# LANGUAGE ScopedTypeVariables #-}
-- | Config is configuration information.
--
--   Not to be confused with Env, which can be built from a Config,
--   but is runtime information (connection pools etc)
module Config where

import qualified Honeycomb          as HC
import           Lens.Micro.Mtl     (view)
import           System.Environment (getEnv)

data Config = Config
  { connstr   :: !ByteString
  , portnum   :: !Int
  , honeyConf :: !HC.HoneyOptions
  }

configFromEnv :: IO Config
configFromEnv = do
  connstr <- encodeUtf8 <$> getEnv "DATABASE_URL"
  portnum :: Int <- fromMaybe (error "must define PORT as integer")
                  . readMaybe <$> getEnv "PORT"
  honeyConf <- HC.honeyOptionsFromEnv
  when (isNothing $ view HC.apiKeyL honeyConf ) $
    error "define HONEYCOMB_API_KEY"
  when (isNothing $ view HC.datasetL honeyConf ) $
    error "define HONEYCOMB_DATASET"

  pure Config{..}
