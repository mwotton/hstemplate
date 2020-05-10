# best-practices haskell template

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

TODO

- hlint hook
- test framework using tmp-postgres to set up test databases
- code coverage check in CI
- deployment
- honeycomb monitoring
- healthchecks
