module PreflightSpec where

import System.Process (readCreateProcessWithExitCode,proc)
import System.Exit(ExitCode(..))
import Test.Hspec

runCommand :: FilePath -> [String] -> IO (ExitCode, String, String)
runCommand cmd args = readCreateProcessWithExitCode (proc cmd args) ""

succeeds :: FilePath -> [String] -> IO ()
succeeds cmd args = runCommand cmd args >>= flip shouldSatisfy (\(x,_,_) -> x==ExitSuccess)

spec :: Spec
spec =
  describe "preflights" $ do
    it "successfully rebuilds the schema" $ succeeds "make" ["schema"]
    it "is hlint-clean" $ succeeds "hlint" ["."]
