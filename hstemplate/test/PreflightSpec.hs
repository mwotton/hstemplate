module PreflightSpec where

import System.Process (readCreateProcessWithExitCode,proc)
import System.Exit(ExitCode(..))
import Test.Hspec

runCommand cmd args = readCreateProcessWithExitCode (proc cmd args) ""

succeeds cmd args = runCommand cmd args >>= flip shouldSatisfy (\(x,_,_) -> x==ExitSuccess)

spec =
  describe "preflights" $ do
    it "successfully rebuilds the schema" $ succeeds "make" ["schema"]
    it "is hlint-clean" $ succeeds "hlint" ["."]
