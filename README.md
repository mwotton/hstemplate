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
TODO

- migration testing
  - possibility for multi-prod system
	- stash databases as docker images: name schema project-YYYY-MM-DD
	- migration tester can build a new image
  - but... we don't really need that. all that we really need is a push to staging and a healthcheck
  - also staging should pull prod's db in order to migrate it?
- announce deploys somewhere
- authn
  - actually provide way to use logged-in status and identity
- authz
  - how hardcore do we want to be?
	- could use https://github.com/Simspace/avaleryar
	- should it be baked into the servant type?
	- probably needs to talk about tiers of service too
- rationing/quotas - not quite the same thing as authz.
  - could we lean on honeycomb instead? set an alert for egregious abuse?
- test framework using tmp-postgres to set up test databases
- coverage ratchet
- payments
  - https://stripe.com/docs/billing/subscriptions/fixed-price#how-to-model-it-on-stripe
  - https://github.com/dmjio/stripe
  - can get rid of the fake endpoints and migrations now, as there will be a real User model.
  - add webhook stuff


RUMINATIONS

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

- healthchecks
  - unclear what to do here.
  - Should a healthcheck failure block a release?
  - what if it's due to external circumstances?
