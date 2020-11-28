module DBSpec where

import           Test.Hspec
import DBHelpers

spec :: Spec
spec = describe "DB" $
  it "can get foos" $
    withSetup $ \conn ->
      pure ()
