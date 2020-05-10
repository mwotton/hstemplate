
all: depcheck haskell

haskell: hstemplate/src/Schema.hs
	stack build --test --bench --no-run-tests --no-run-benchmarks

testwatch:
	ghcid -T :main -c 'stack repl hstemplate:lib hstemplate:test:hstemplate-test' --restart="hstemplate/package.yaml" --restart="stack.yaml" --restart=verify $(foreach file, $(DBDEPS), "--restart=$(file)")

.PHONY: depcheck
depcheck: sqitch

.PHONY: sqitch
sqitch:
	bash -c "sqitch --help >& /dev/null || echo 'download sqitch first'"

DBDEPS=$(wildcard verify/* deploy/* revert/*)

hstemplate/src/Schema.hs: $(DBDEPS)
	bash ./scripts/gen_schema.sh
