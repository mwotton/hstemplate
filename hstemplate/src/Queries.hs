{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE KindSignatures #-}

--{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators #-}

module Queries where

import Schema (DB)
import Squeal.PostgreSQL hiding (name)
import Types (Foo)
import Data.Time(UTCTime)

getAllFoosQ :: Statement DB () Foo
getAllFoosQ = query $ select_ (#id :* #name) (from $ table (#hstemplate ! #foos))


getTimeQ :: Statement DB () (Only UTCTime)
getTimeQ = query q
  where
    q :: Query '[] '[] DB '[] '["fromOnly" ::: 'NotNull 'PGtimestamptz]
    q = values_ (now `as` #fromOnly)
