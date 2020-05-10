{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module Types where

import qualified Generics.SOP as SOP
import qualified GHC.Generics as GHC

data Foo = Foo
  { name :: Text
  } deriving stock (Show, GHC.Generic)
    deriving anyclass (SOP.Generic, SOP.HasDatatypeInfo)
