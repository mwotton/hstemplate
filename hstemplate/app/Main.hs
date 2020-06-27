{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
module Main where

import           API                      (API)
import           Config                   (Config (..), configFromEnv)
import           Control.Exception        (try)
import           Env                      (Env, buildEnv, connectionPool)
-- import           Middleware               (honeyMiddleware)
import           Honeycomb.Trace
import           Manager                  (AppT, runApp)
import qualified Manager
import           Network.Wai              (Application, Middleware)
import           Network.Wai.Handler.Warp (run)
import           Network.Wai.Honeycomb    (MiddlewareT, liftApplication,
                                           runApplicationT, runMiddlewareT,
                                           traceApplicationT)
import           Servant.Server           (Handler (..), hoistServer, serve)
import           Server                   (api, server)
import           Squeal.PostgreSQL        (MonadPQ (..), PQ,
                                           usingConnectionPool)

main :: IO ()
main = do
  config@Config{..} <- configFromEnv
  env <- buildEnv config
  run portnum =<< (`runReaderT` env) (runApplicationT (traceApplicationT (ServiceName "hstemplate") (SpanName "some span") $ liftApplication $ app env))


app :: Env -> Application
app env = serve api $ hoistServer api (nt env) server



nt :: Env -> Manager.App x -> Handler x
nt env = Handler . ExceptT . try . runApp env
