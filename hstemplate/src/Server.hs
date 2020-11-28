{-# OPTIONS_GHC -fno-warn-deprecations #-}

module Server where

import           API                    (API, api, Routes (..))
import           Manager                (App, runDB, runApp)
import           Queries                (getAllFoosQ)
import Env
import Control.Exception(try)
import           Servant                (ServerT, Handler(..))
import           Servant.Server.Generic (genericServerT)
import           Squeal.PostgreSQL      (execute, getRows)
import Servant.Server (hoistServer)




-- probably this should have a custom monad but it doesn't bother
-- me too badly for now.
server :: ServerT API App
server = genericServerT $ Routes
  { getFoos = do
      liftIO $ putStrLn "Getting foos!"
      r <- runDB $ getRows =<< execute getAllFoosQ
      liftIO $ putStrLn "got foos!"
      pure r

  , someInt = pure 12
  }
--  where run = liftIO . runApp e

hoistedServer env = hoistServer api (nt env) server

nt :: Env -> Manager.App x -> Handler x
nt env = Handler . ExceptT . try . runApp env
