# best-practices haskell template

This is a distillation of all the annoying tasks I end up setting up
anyway.

DONE

- top level monorepo, package directories beneath

I almost always end up structuring apps as a collection of packages anyway, so
it makes sense to set it up that way from the beginning

- stack

this is probably the most controversial thing here, and the one I'm least
wedded to.

- Makefile for task-running

needs _something_ for things like preflights and non-haskell dependency checking

- servant api
  done-ish, still needs a hookup from servant api to squeal monad
- postgres/squeal backend
- migrations with sqitch
- ormolu/hlint hooks

TODO

- test framework using tmp-postgres to set up test databases
- CI integration
   - github actions/laminar?
   - coverage
- deployment
- honeycomb monitoring
- healthchecks
