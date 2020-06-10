{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE RecordWildCards     #-}
{-# LANGUAGE ScopedTypeVariables #-}
-- | Config is configuration information.
--
--   Not to be confused with Env, which can be built from a Config,
--   but is runtime information (connection pools etc)
module Config where

import           Data.ByteString
import           System.Environment (getEnv)

data Config = Config
  { connstr :: ByteString
  , portnum :: Int
  }

configFromEnv :: IO Config
configFromEnv = do
  connstr <- encodeUtf8 <$> getEnv "DATABASE_URL"
  portnum :: Int <- fromMaybe (error "must define PORT as integer")
                  . readMaybe <$> getEnv "PORT"
  pure Config{..}
