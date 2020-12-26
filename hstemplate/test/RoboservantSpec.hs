{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE DerivingVia #-}


module RoboservantSpec where

import DBHelpers
import AroundAll
import Manager
import API
import Server
import Roboservant
import Hedgehog
import Test.Hspec
import qualified Roboservant as RS
import Env(Env)
import Types(Foo)

defaultConfig :: RS.Config
defaultConfig = RS.Config
                { RS.seed = []
                , RS.maxRuntime = 0.5
                , RS.maxReps = 1000
                , RS.rngSeed = 0
                , RS.coverageThreshold = 0
                }

spec :: Spec
spec = describe "api" $ do
  aroundAll withEnv $
    it "works sequentially" $ \env -> do
      RS.fuzz @API (hoistedServer env) defaultConfig (pure ())
        >>= (`shouldSatisfy` isNothing)


deriving via RS.Atom Foo instance RS.Breakdown Foo
instance (Hashable x, Typeable x, RS.Breakdown x) => RS.Breakdown [x] where
  breakdownExtras r = hashedDyn r:fmap hashedDyn r
