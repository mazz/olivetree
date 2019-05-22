# docker build -t olivetree:builder --target=builder .
FROM elixir:1.8.1-alpine as builder
RUN apk add --no-cache \
    gcc \
    git \
    make \
    musl-dev
RUN mix local.rebar --force && \
    mix local.hex --force
WORKDIR /app
ENV MIX_ENV=prod

# docker build -t olivetree:deps --target=deps .
FROM builder as deps
COPY mix.* /app/
# Explicit list of umbrella apps
RUN mkdir -p \
    /app/apps/db \
    /app/apps/olivetree \
    /app/apps/olivetree_jobs \
    /app/apps/olivetree_api
COPY apps/db/mix.* /app/apps/db/
COPY apps/olivetree/mix.* /app/apps/olivetree/
COPY apps/olivetree_jobs/mix.* /app/apps/olivetree_jobs/
COPY apps/olivetree_api/mix.* /app/apps/olivetree_api/
RUN mix do deps.get --only prod, deps.compile

# docker build -t olivetree:frontend --target=frontend .
FROM node:10.14-alpine as frontend
WORKDIR /app
COPY apps/olivetree_api/assets/package*.json /app/
COPY --from=deps /app/deps/phoenix /deps/phoenix
COPY --from=deps /app/deps/phoenix_html /deps/phoenix_html
COPY --from=deps /app/deps/phoenix_live_view /deps/phoenix_live_view
RUN npm ci
COPY apps/olivetree_api/assets /app
RUN npm run deploy

# docker build -t olivetree:releaser --target=releaser .
FROM deps as releaser
COPY . /app/
COPY --from=frontend /priv/static apps/olivetree_api/priv/static
RUN mix do phx.digest, release --env=prod --no-tar

# docker run -it --rm elixir:1.7.3-alpine sh -c 'head -n1 /etc/issue'
FROM alpine:3.9 as runner
RUN addgroup -g 1000 olivetree && \
    adduser -D -h /app \
      -G olivetree \
      -u 1000 \
      olivetree
RUN apk add -U --no-cache bash coreutils grep sed libssl1.1
USER root
WORKDIR /app
COPY --from=releaser /app/_build/prod/rel/olivetree_umbrella /app
EXPOSE 80
ENTRYPOINT ["/app/bin/olivetree_umbrella"]
CMD ["foreground"]
