
all: depcheck haskell

haskell: hstemplate/src/Schema.hs
	stack build --test --bench --no-run-tests --no-run-benchmarks

hlint:
	hlint .

DBDEPS=$(wildcard verify/* deploy/* revert/*)

.PHONY: schema
schema: hstemplate/src/Schema.hs

hstemplate/src/Schema.hs: $(DBDEPS)
	bash ./scripts/gen_schema.sh

testwatch:
	ghcid -T :main -c 'stack repl hstemplate:lib hstemplate:test:hstemplate-test' --restart="hstemplate/package.yaml" --restart="stack.yaml" --restart=verify $(foreach file, $(DBDEPS), "--restart=$(file)")

.PHONY: depcheck
depcheck: ormolu sqitch squealgen

.PHONY: sqitch
sqitch:
	bash -c "sqitch --help >& /dev/null || echo 'download sqitch first'"

.PHONY: squealgen
squealgen:
	bash -c "squealgen >& /dev/null || echo 'download squealgen first'"

.PHONY: ormolu
ormolu:
	bash -c "ormolu >& /dev/null || echo 'download ormolu first'"

docker-build:
	@stack build
	@BINARY_PATH=${BINARY_PATH_RELATIVE} docker-compose build
