{-# OPTIONS_GHC -fno-warn-deprecations #-}

module Server where

import           API                            (API, Routes (..))
import           Env                            (Env (..))
import           Manager                        (runApp)
import           Queries                        (getAllFoosQ)
import           Servant                        (Server)
import           Servant.Server.Generic         (genericServer)
import           Squeal.PostgreSQL              (execute, getRows)
import           Squeal.PostgreSQL.Session.Pool (usingConnectionPool)

-- probably this should have a custom monad but it doesn't bother
-- me too badly for now.
server :: Env -> Server API
server e = genericServer $  Routes
  { getFoos = run (getRows =<< execute getAllFoosQ)
  , someInt = run (pure 12)
  }
  where run = liftIO . runApp e
