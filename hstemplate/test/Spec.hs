{-# LANGUAGE OverloadedStrings #-}
import qualified DBSpec
import qualified PreflightSpec
import           Queries
import           Squeal.PostgreSQL
import           Test.Hspec

main :: IO ()
main = hspec spec

spec :: Spec
spec = describe "hstemplate" $ do
  PreflightSpec.spec
  -- silly test to check coverage
  it "serialises" $
    renderSQL getAllFoosQ `shouldBe` renderSQL getAllFoosQ
  DBSpec.spec
