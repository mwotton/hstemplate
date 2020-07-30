{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}

module Types where

import Data.Aeson(ToJSON, FromJSON)
import qualified GHC.Generics as GHC
import qualified Generics.SOP as SOP

data Foo
  = Foo
      { id :: Int32
      , name :: Text
      }
  deriving stock (Show, GHC.Generic, Eq)
  deriving anyclass (SOP.Generic, SOP.HasDatatypeInfo)

instance FromJSON Foo
instance ToJSON Foo
