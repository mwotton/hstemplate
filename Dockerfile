FROM fpco/stack-build:lts-15.11 as build
RUN mkdir /opt/build
COPY . /opt/build
RUN cd /opt/build && stack install --system-ghc --only-dependencies
RUN cd /opt/build && stack install --system-ghc

FROM heroku/heroku:18.nightly as server
RUN mkdir -p /opt/myapp
ARG BINARY_PATH
WORKDIR /opt/myapp
RUN apt-get update && apt-get install -y \
  ca-certificates \
  libgmp-dev libpq5
# NOTICE THIS LINE
COPY --from=build /root/.local/bin .
# COPY static /opt/myapp/static
# COPY config /opt/myapp/config
CMD ["/opt/myapp/server"]
