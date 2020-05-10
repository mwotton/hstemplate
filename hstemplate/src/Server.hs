{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -fno-warn-deprecations #-}

module Server where

import API
import Env (Env (..))
-- import Queries (getAllFoosQ)
import Servant
-- import Squeal.PostgreSQL (execute, getRows)
-- import Squeal.PostgreSQL.Session.Pool (usingConnectionPool)

--app :: Application
-- app = serve (Proxy :: Proxy API) _server

server :: Env -> Server API
server Env {..} = undefined
-- needs a monad
-- usingConnectionPool connectionPool $
--   getRows =<< execute getAllFoosQ
