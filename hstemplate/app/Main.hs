{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
module Main where

import           Auth
import           Config                   (Config (..), configFromEnv)
import           Control.Exception        (try)
import           Env                      (Env, withEnv)
import           Honeycomb.Trace
import           Manager                  (runApp)
import qualified Manager
import           Network.Wai              (Application)
import           Network.Wai.Handler.Warp (run)
import           Network.Wai.Honeycomb    (liftApplication, runApplicationT,
                                           traceApplicationT)
import           Servant.Server           (Handler (..), hoistServer, serve)
import           Server                   (server, nt)
import API(api)

main :: IO ()
main = do
  config@Config{..} <- configFromEnv
  withEnv config $ \env  ->
    run portnum =<< setupMiddleware config env (app env)


setupMiddleware :: Config -> Env -> Application -> IO Application
setupMiddleware config env myapp = do
  authMiddleware <- genAuthMiddleware config
  honeyMid $ authMiddleware myapp

  where
    -- TODO refactor this to IO Middleware
    honeyMid :: Application -> IO Application
    honeyMid baseApp =
      (`runReaderT` env)
      (runApplicationT (traceApplicationT (ServiceName "hstemplate") (SpanName "some span")
                        $ liftApplication baseApp))

app :: Env -> Application
app env = serve api $ hoistServer api (nt env) server
