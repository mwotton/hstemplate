{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
module Main where

import           Config                   (Config (..), configFromEnv)
import           Control.Exception        (try)
import           Env                      (Env, withEnv)
-- import           Middleware               (honeyMiddleware)
import           Auth
import           Honeycomb.Trace
import           Manager                  (runApp)
import qualified Manager
import           Network.Wai              (Application)
import           Network.Wai.Handler.Warp (run)
import           Network.Wai.Honeycomb    (liftApplication, runApplicationT,
                                           traceApplicationT)
import           Servant.Server           (Handler (..), hoistServer, serve)
import           Server                   (api, server)


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



nt :: Env -> Manager.App x -> Handler x
nt env = Handler . ExceptT . try . runApp env
