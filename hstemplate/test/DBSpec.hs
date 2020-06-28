module DBSpec where

import           AroundAll              ()
import           Database.Postgres.Temp
import           Test.Hspec

spec :: Spec
spec = describe "DB" $ do
  it "can get foos" $
    withDbCache $ \_cache ->
      () `shouldBe` ()
  it "does other stuff" $
    () `shouldBe` ()
