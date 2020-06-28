{-# OPTIONS_GHC -fno-warn-deprecations #-}

module Server where

import           API                    (API, Routes (..))
import           Manager                (App)
import           Queries                (getAllFoosQ)
import           Servant                (ServerT)
import           Servant.Server.Generic (genericServerT)
import           Squeal.PostgreSQL      (execute, getRows)



-- probably this should have a custom monad but it doesn't bother
-- me too badly for now.
server :: ServerT API App
server = genericServerT $  Routes
  { getFoos = getRows =<< execute getAllFoosQ
  , someInt = pure 12
  }
--  where run = liftIO . runApp e

api :: Proxy API
api = Proxy
