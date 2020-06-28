{-# LANGUAGE LambdaCase #-}
module PreflightSpec where

import           System.Exit    (ExitCode (..))
import           System.Process (proc, readCreateProcessWithExitCode)
import           Test.Hspec

runCommand :: FilePath -> [String] -> IO (ExitCode, String, String)
runCommand cmd args = readCreateProcessWithExitCode (proc cmd args) ""

succeeds :: FilePath -> [String] -> IO ()
succeeds cmd args = runCommand cmd args >>= \case
  (ExitSuccess,_,_) -> pure ()
  (e,output,errOut) -> expectationFailure
    (toString $ unlines $ map toText
      ["Exit code: " <> show e
      ,"Cmd:       " <> cmd
      ,"Output:    " <> output
      ,"Err:       " <> errOut])


spec :: Spec
spec =
  describe "preflights" $ do
    it "successfully rebuilds the schema" $ succeeds "make" ["schema"]
    it "is hlint-clean" $ succeeds "hlint" ["."]
