{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}

module Types where

import Data.Aeson(ToJSON)
import qualified GHC.Generics as GHC
import qualified Generics.SOP as SOP
import Data.Hashable

data Foo
  = Foo
      { id :: Int32
      , name :: Text
      }
  deriving stock (Show, GHC.Generic, Eq)
  deriving anyclass (SOP.Generic, SOP.HasDatatypeInfo)

instance Hashable Foo
instance ToJSON Foo
