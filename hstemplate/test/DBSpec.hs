module DBSpec where

import           AroundAll              ()
import           Database.Postgres.Temp
import           Test.Hspec

spec :: Spec
spec = describe "DB" $ do
  it "can get foos" $
    -- possibly should also migrate & cacheAction
    withDbCache $ \cache -> withConfig (cacheConfig cache) $ \db -> do
      let x = (toConnectionString db)
      () `shouldBe` ()
