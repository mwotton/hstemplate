# best-practices haskell template

![CI](https://github.com/mwotton/hstemplate/workflows/CI/badge.svg)

This is a distillation of all the annoying tasks I end up setting up
anyway.

DONE

- top level monorepo, package directories beneath

I almost always end up structuring apps as a collection of packages anyway, so
it makes sense to set it up that way from the beginning

- no default-extensions

they are convenient, but it always seems to break tooling. Put the extensions you need in the file and be done with it.

- stack

this is probably the most controversial thing here, and the one I'm
least wedded to. it works well enough for now.

- ghcide-friendly

this one is rough. ghcide is great, but [this bug](https://github.com/digital-asset/ghcide/issues/113) means that you have to include test dependencies at the top level. Hopefully this will be fixed soon.

- Makefile for task-running

needs _something_ for things like preflights and non-haskell dependency checking

- servant api
  done-ish, still needs a hookup from servant api to squeal monad
- postgres/squeal backend
- migrations with sqitch
- ormolu hook
- CI github action
- deployment
  - heroku/docker deployment, sqitch container for migrations.
- code coverage is recorded
  - only get a zip file. cooler if this worked https://github.com/actions/upload-artifact/issues/62#issuecomment-601472239 - in the works.

TODO

- property enforcement mechanisms
  - emacs save hook
  - ghc source plugin
	- cool idea, but needs to be added to the dependencies. devflag?
  - commit-hook
	- still need to run installer script
  - post-commit github action

- desirable properties
  - hlint
  - remove unused imports
  - autoformat
- current situation
  - hlint/emacs save hook
  - autoformatting via git hook
- possible replacements
  - hlint/source plugin
	- https://hackage.haskell.org/package/splint
  - unused-imports/source-plugin
	- https://github.com/kowainik/smuggler
- non-enforcement source plugins
  - https://github.com/ArturGajowy/ghc-clippy-plugin/ better error messages

- test framework using tmp-postgres to set up test databases
- coverage ratchet
- honeycomb monitoring
  - https://github.com/EarnestResearch/honeycomb-wai-haskell/blob/master/src/Network/Wai/Honeycomb.hs
    wai middleware for honeycomb, not more general
  - https://github.com/ChrisCoffey/haskell-opentracing-light#readme
    a light opentracing-compliant lib
  - https://github.com/kim/opentracing/tree/master/opentracing
	full-featured, heavier deps
  - https://github.com/honeycombio/honeycomb-opentracing-proxy
	- honeycomb has a proxy that can talk opentracing
	- awkward for heroku: needs a second docker image, which costs money
- healthchecks
