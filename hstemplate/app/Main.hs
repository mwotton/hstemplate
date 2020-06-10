{-# LANGUAGE RecordWildCards  #-}
{-# LANGUAGE TypeApplications #-}
module Main where

import           API                      (API)
import           Config                   (Config (..), configFromEnv)
import           Data.Proxy               (Proxy)
import           Env                      (buildEnv)
import           Network.Wai.Handler.Warp (run)
import           Servant.Server           (serve)
import           Server                   (server)

main :: IO ()
main = do
  config@Config{..} <- configFromEnv
  env <- buildEnv config
  run portnum $ serve (Proxy @API) (server env)
