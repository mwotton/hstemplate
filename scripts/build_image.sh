#!/bin/bash

set -euo pipefail

docker pull mwotton/hstemplate:compile-stage || true
docker pull mwotton/hstemplate:latest || true

# Build the compile stage:
docker build --target build \
       --cache-from=mwotton/hstemplate:compile-stage \
       --tag mwotton/hstemplate:compile-stage .

docker push mwotton/hstemplate:compile-stage
# Build the runtime stage, using cached compile stage:
docker build --target server \
       --cache-from=mwotton/hstemplate:compile-stage \
       --cache-from=mwotton/hstemplate:latest \
       --tag mwotton/hstemplate:latest .
docker push mwotton/hstemplate:latest
