# SPDX-License-Identifier: Apache-2.0
#!BuildTag: trento/trento-web:latest
#!BuildTag: trento/trento-web:%%VERSION%%
#!BuildTag: trento/trento-web:%%VERSION%%-build%RELEASE%
#!UseOBSRepositories

FROM bci/bci-base:15.3 AS elixir-build
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN zypper --non-interactive in sles-release
RUN zypper -n in elixir rust cargo
COPY . /build
WORKDIR /build
ARG MIX_ENV=prod
ENV MIX_ENV=$MIX_ENV
RUN mix local.rebar --force \
    && mix local.hex --force \
    && mix deps.get

FROM elixir-build AS release
COPY --from=elixir-build /build /build
WORKDIR /build
ARG MIX_ENV=prod
ENV MIX_ENV=$MIX_ENV
ENV VERSION=%%VERSION%%
RUN mix phx.digest
RUN mix release

FROM registry.suse.com/bci/bci-base:15.3 AS wanda
LABEL org.opencontainers.image.source="https://github.com/trento-project/wanda"
ARG MIX_ENV=prod
ENV MIX_ENV=$MIX_ENV
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
WORKDIR /app
COPY --from=release /build/_build/$MIX_ENV/rel/wanda .
EXPOSE 4000/tcp
ENTRYPOINT ["/app/bin/wanda"]