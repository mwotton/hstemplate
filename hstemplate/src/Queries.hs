{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedLabels #-}

--{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators #-}

module Queries where

import Schema (DB)
import Squeal.PostgreSQL hiding (name)
import Types (Foo)

getAllFoosQ :: Statement DB () Foo
getAllFoosQ = query $ select_ (#id :* #name) (from $ table (#hstemplate ! #foos))
