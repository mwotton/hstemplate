{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}
module API where

import Servant
import Servant.API.Generic
import Types

type API = Get '[JSON] [Foo]


data Routes route = Routes
    { _get :: route :- Get '[JSON] [Foo]
    }
  deriving (Generic)

api :: Proxy API
api = genericApi (Proxy @Routes)
