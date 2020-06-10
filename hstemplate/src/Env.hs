module Env where

-- import qualified Database.PostgreSQL.Simple.Options as PGconnstr
import           Config            (Config (..))
import           Schema            (DB)
import           Squeal.PostgreSQL
--import Squeal.PostgreSQL.Session.Pool (Pool, usingConnectionPool)

--  { connection :: PGconnstr.Options }

buildEnv :: Config -> IO Env
buildEnv = undefined

data Env
  = Env
      {connectionPool :: Pool (K Connection DB)}
