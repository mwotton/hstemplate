
all: depcheck haskell

haskell: hstemplate/src/Schema.hs
	stack build --test --bench --no-run-tests --no-run-benchmarks

testwatch:
	ghcid -T :main -c 'stack repl hstemplate:lib hstemplate:test:hstemplate-test' --restart="hstemplate/package.yaml" --restart="stack.yaml"

.PHONY: depcheck
depcheck: sqitch

.PHONY: sqitch
sqitch:
	bash -c "sqitch --help >& /dev/null || echo 'download sqitch first'"

hstemplate/src/Schema.hs:
	bash ./scripts/gen_schema.sh
