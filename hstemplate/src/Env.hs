module Env where

import qualified Database.PostgreSQL.Simple.Options as PGconnstr
import Squeal.PostgreSQL.Session.Pool(Pool,usingConnectionPool)
import Squeal.PostgreSQL
import Schema(DB)

--  { connection :: PGconnstr.Options }

data Env = Env
  { connectionPool :: Pool (K Connection DB) }
