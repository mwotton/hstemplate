{-# LANGUAGE DataKinds        #-}
{-# LANGUAGE DeriveGeneric    #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators    #-}

module API where

import           Servant
import           Servant.API.Generic
import           Types

type API = ToServantApi Routes

data Routes route
  = Routes
      { getFoos :: route :-
        "foos" :> Get '[JSON] [Foo]
      , someInt :: route :-
        "int" :> Get '[JSON] Int
      , takeFooAndCrash :: route :-
        "fooAndCrash" :> ReqBody '[JSON] Foo :> Post '[JSON] NoContent
      }
  deriving (Generic)

api :: Proxy (ToServantApi Routes)
api = genericApi (Proxy @Routes)
