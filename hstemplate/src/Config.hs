{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE RecordWildCards     #-}
{-# LANGUAGE ScopedTypeVariables #-}
-- | Config is configuration information.
--
--   Not to be confused with Env, which can be built from a Config,
--   but is runtime information (connection pools etc)
module Config where

import qualified Data.HashMap.Strict                       as HM
import qualified Honeycomb                                 as HC
import           Lens.Micro.Mtl                            (view)
import           Network.Wai.Middleware.Auth.OAuth2.Github (Github (..),
                                                            mkGithubProvider)
import           Network.Wai.Middleware.Auth.Provider      (Provider (..))
import           System.Environment                        (getEnv,
                                                            getEnvironment)



data Config = Config
  { connstr       :: !ByteString
  , portnum       :: !Int
  , honeyConf     :: !HC.HoneyOptions
  , honeyEnabled  :: Bool
  , authProviders :: [Provider]
  }

configFromEnv :: IO Config
configFromEnv = do
  connstr <- encodeUtf8 <$> getEnv "DATABASE_URL"
  portnum :: Int <- fromMaybe (error "must define PORT as integer")
                  . readMaybe <$> getEnv "PORT"
  honeyConf <- HC.honeyOptionsFromEnv
  when (isNothing $ view HC.apiKeyL honeyConf ) $
    fail "define HONEYCOMB_API_KEY"
  when (isNothing $ view HC.datasetL honeyConf ) $
    fail "define HONEYCOMB_DATASET"
  env <- HM.fromList <$> getEnvironment
  let authProviders = catMaybes [Provider <$> parseGithubProvider env]
  when (null authProviders) $
    fail "Must have at least one auth provider"
  honeyEnabled <- fromMaybe (error "define ENABLE_HONEYCOMB") . readMaybe
                 <$> getEnv "ENABLE_HONEYCOMB"
  pure Config{..}

parseGithubProvider :: HM.HashMap String String -> Maybe Github
parseGithubProvider e = let l = flip HM.lookup e in
  mkGithubProvider
  <$> fmap toText (l "GITHUB_APPNAME")
  <*> fmap toText (l "GITHUB_CLIENT_ID")
  <*> fmap toText (l "GITHUB_CLIENT_SECRET")
  <*> Just (maybe [] (pure . fromString) $ l "GITHUB_EMAIL_WHITELISTS")
  <*> Just Nothing
