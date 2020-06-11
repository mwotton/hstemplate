#!/bin/bash

set -euo pipefail

docker pull mwotton/hstemplate-dependencies:latest || true

docker build --target dependencies \
       --cache-from=mwotton/hstemplate-dependencies:latest \
       --tag mwotton/hstemplate-dependencies .

docker push mwotton/hstemplate-dependencies:latest

# Build the runtime stage, using cached compile stage:
docker build --target server \
       --cache-from=mwotton/hstemplate-dependencies:latest \
       --tag mwotton/hstemplate-server .
docker push mwotton/hstemplate-server:latest
