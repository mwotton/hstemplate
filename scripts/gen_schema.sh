#!/bin/env bash

set -euo pipefail
IFS=$'\n\t'

uri=$(pg_tmp -w 300)
sqitch deploy -t "${uri}"
squealgen "${uri}" Schema hstemplate | ormolu > $(git rev-parse --show-toplevel)/hstemplate/src/Schema.hs
