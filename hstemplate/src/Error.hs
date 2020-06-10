{-# LANGUAGE LambdaCase #-}
module Error where

import           Servant           (ServerError, err412, err500)
import           Squeal.PostgreSQL

sqlError :: SquealException -> ServerError
sqlError = \case
  ConnectionException{} -> err500
  ColumnsException{} -> err500
  RowsException{} -> err500
  DecodingException {} -> err500
  CheckViolation{} -> err412
  UniqueViolation{} -> err412
  SQLException SQLState {} -> err500
