#!/bin/env bash

set -euo pipefail
IFS=$'\n\t'

uri=$(pg_tmp -w 300)
sqitch deploy -t "${uri}"
#psql "${uri}"
squealgen "${uri}" Schema hstemplate
squealgen "${uri}" Schema hstemplate > $(git rev-parse --show-toplevel)/hstemplate/src/Schema.hs

echo ${uri}
