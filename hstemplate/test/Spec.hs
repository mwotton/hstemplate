import System.Process (rawSystem)
import System.Exit(ExitCode(..))
import Test.Hspec

main :: IO ()
main = do
  regenerateSchema
  putStrLn "Test suite not yet implemented"


regenerateSchema = do
  -- this is a tad sketchy - we just delegate this to the
  -- makefile above
  code <- rawSystem "make" ["schema"]
  case code of
    ExitSuccess -> pure ()
    _ -> exitWith code
