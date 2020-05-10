{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}

module Types where

import qualified GHC.Generics as GHC
import qualified Generics.SOP as SOP
import Data.Int(Int64)

data Foo
  = Foo
      { id :: Int32
      , name :: Text
      }
  deriving stock (Show, GHC.Generic)
  deriving anyclass (SOP.Generic, SOP.HasDatatypeInfo)
