import qualified PreflightSpec
import           Test.Hspec

main :: IO ()
main = hspec spec

spec :: Spec
spec = describe "hstemplate" $ do
  PreflightSpec.spec
  -- awful hack: i don't want to turn the "redundant do" hlint flag on,
  -- but this is the standard form for hspec tests.

  pure ()
