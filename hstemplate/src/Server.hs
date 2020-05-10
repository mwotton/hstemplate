{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -fno-warn-deprecations #-}
module Server where

import API
import Servant
import Queries(getAllFoosQ)
import Env(Env(..))
import Squeal.PostgreSQL.Session.Pool(usingConnectionPool)
import Squeal.PostgreSQL(getRows,execute)

--app :: Application
-- app = serve (Proxy :: Proxy API) _server

server :: Env -> Server API
server Env{..} = undefined
  -- needs a monad
  -- usingConnectionPool connectionPool $
  --   getRows =<< execute getAllFoosQ
