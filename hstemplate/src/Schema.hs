-- | This code was originally created by squealgen. Edit if you know how it got made and are willing to own it now.
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE GADTs #-}
{-# OPTIONS_GHC -fno-warn-unticked-promoted-constructors #-}

module Schema where
import Squeal.PostgreSQL
import GHC.TypeLits(Symbol)

-- squeal doesn't yet support cidr or ltree, so for the moment we emit them explicitly
type PGcidr = UnsafePGType "cidr"
type PGltree = UnsafePGType "ltree"

type DB = '["hstemplate" ::: Schema]

type Schema = Join Tables Enums
-- enums

-- decls
type Enums =
  ('[] :: [(Symbol,SchemumType)])
-- schema
type Tables = ('[
   "foos" ::: 'Table FoosTable]  :: [(Symbol,SchemumType)])

-- defs
type FoosColumns = '["id" ::: 'Def :=> 'NotNull PGint4
  ,"name" ::: 'NoDef :=> 'NotNull PGtext]
type FoosConstraints = '["foos_pkey" ::: 'PrimaryKey '["id"]]
type FoosTable = FoosConstraints :=> FoosColumns

-- VIEWS
