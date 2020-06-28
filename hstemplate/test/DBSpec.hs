module DBSpec where

import           AroundAll
import           Database.Postgres.Temp
import           Test.Hspec

spec = describe "DB" $ do
  it "can get foos" $
    withDbCache $ \cache -> do

    () `shouldBe` ()
  it "does other stuff" $
    () `shouldBe` ()
