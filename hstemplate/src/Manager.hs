{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE UndecidableInstances       #-}
{-# LANGUAGE PolyKinds       #-}
{-# LANGUAGE DerivingVia       #-}
module Manager where

-- import           Control.Monad.Logger
import           Env
import           Error                ()
import           Schema
import           Squeal.PostgreSQL    (MonadPQ (..), PQ,
                                       usingConnectionPool)
import           UnliftIO (MonadUnliftIO(..))
import Control.Monad.Catch (MonadCatch, MonadThrow, MonadMask)

instance MonadUnliftIO m => MonadUnliftIO (AppT r m) where
  withRunInIO inner =
    AppT $
    ReaderT $ \r ->
    withRunInIO $ \run ->
    inner (run . flip runReaderT r . unAppT)

instance (db ~ DB, MonadPQ db m) => MonadPQ db (AppT r m) where
  executeParams q = lift . executeParams q
  executePrepared q = lift . executePrepared q
  executePrepared_ q = lift . executePrepared_ q

-- TODO: choose a logging framework
newtype AppT r m a = AppT { unAppT :: ReaderT r m a }
  deriving newtype
    ( Functor
    , Applicative
    , Monad
    , MonadReader r
    , MonadIO
    , MonadCatch
    , MonadThrow
    , MonadMask
    )


instance MonadTrans (AppT r) where
  lift = AppT . lift

type App = AppT Env (PQ DB DB IO)

-- runAppInTransaction :: Env -> App a -> IO a

runApp :: MonadUnliftIO io
       =>  Env
       -> AppT Env (PQ DB DB io)  x
       -> io x

runApp env =
    usingConnectionPool (connectionPool env)
  . flip runReaderT env
  . unAppT
