{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes        #-}
module AroundAll where

import           Control.Concurrent.Async (async, cancel, race, wait)
import           Test.Hspec

aroundAll :: forall a. ((a -> IO ()) -> IO ()) -> SpecWith a -> Spec
aroundAll withFunc specWith = do
  (var, stopper, asyncer) <- runIO $
    (,,) <$> newEmptyMVar <*> newEmptyMVar <*> newIORef Nothing
  let
      theStart = do

        thread <- async $ do
          withFunc $ \x -> do
            putMVar var x
            takeMVar stopper
          pure $ error "Don't evaluate this"

        writeIORef asyncer $ Just thread

        either pure pure =<< (wait thread `race` takeMVar var)

      theStop :: a -> IO ()
      theStop _ = do
        putStrLn "aroundall stopping"
        putMVar stopper ()
        putStrLn "aroundall putMvar"
        traverse_ cancel =<< readIORef asyncer
        putStrLn "aroundall stopped"


  beforeAll theStart $ afterAll theStop specWith
