# best-practices haskell template

This is a distillation of all the annoying tasks I end up setting up
anyway.

1. top level monorepo, package directories beneath

I almost always end up structuring apps as a collection of packages anyway, so
it makes sense to set it up that way from the beginning

2. servant api
3. postgres/squeal backend
4. migrations with sqitch
5. test framework using tmp-postgres to set up test databases
6. CI integration
   - github actions/laminar?
   - coverage
7. ormolu/hlint hooks
8. deployment
9. honeycomb monitoring
10. healthchecks
11. stack

this is probably the most controversial thing here, and the one I'm least
wedded to.

12. Makefile for task-running

needs _something_ for things like preflights and non-haskell dependency checking
