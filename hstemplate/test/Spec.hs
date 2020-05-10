import System.Process(rawSystem)

main :: IO ()
main = do
  regenerateSchema

  putStrLn "Test suite not yet implemented"

-- could make this cleverer but it'll do for now
regenerateSchema = rawSystem "make" ["hstemplate/src/Schema.hs"]
