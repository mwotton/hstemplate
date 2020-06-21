{-# LANGUAGE RecordWildCards #-}
module Env where

-- import qualified Database.PostgreSQL.Simple.Options as PGconnstr
import           Config            (Config (..))
import           Schema            (DB)
import           Squeal.PostgreSQL

--  { connection :: PGconnstr.Options }

buildEnv :: Config -> IO Env
buildEnv Config {..} = do
  connectionPool <- createConnectionPool connstr 1 0.5 20
  pure Env{..}

data Env
  = Env
      {connectionPool :: Pool (K Connection DB)}
