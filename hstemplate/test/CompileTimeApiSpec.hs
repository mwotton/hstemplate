{-# OPTIONS_GHC -fdefer-type-errors #-}
module CompileTimeApiSpec where

import API
import Servant.Validate
import Test.Hspec

testApi :: Proxy API
testApi = Proxy

validTestApi :: ValidApiTree API
validTestApi = validApiTree testApi

spec = describe "compile time tests" $ do
  it "has a valid api" $ do
    validTestApi `seq` (() `shouldBe` ())
