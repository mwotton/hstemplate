# DONE

- better squeal hookup: don't want to take a connection from the pool if we might not
  actually be doing any database work.
- servant api
- postgres/squeal backend
- migrations with sqitch
- ormolu hook
- CI github action
- deployment
  - heroku/docker deployment, sqitch container for migrations.
- code coverage is recorded
  - only get a zip file. cooler if this worked https://github.com/actions/upload-artifact/issues/62#issuecomment-601472239 - in the works.
- honeycomb monitoring
  - https://github.com/EarnestResearch/honeycomb-wai-haskell/blob/master/src/Network/Wai/Honeycomb.hs
    wai middleware for honeycomb, not more general
- authn
  - https://hackage.haskell.org/package/wai-middleware-auth looks reasonable?
- test framework using tmp-postgres to set up test databases
