module DBSpec where

import           Test.Hspec
import DBHelpers

spec :: Spec
spec = describe "DB" $
  it "can get foos" $
    1 `shouldBe` 1
