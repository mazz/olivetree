# Since configuration is shared in umbrella projects, this file
# should only configure the :olivetree_api application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :olivetree_api, OlivetreeApi.Endpoint,
  http: [port: 4002],
  server: false

config :logger,
  level: :debug,
  backends: [:console],
  compile_time_purge_level: :debug


# config :olivetree_api, OlivetreeApi.Auth.Guardian,
#   issuer: "OlivetreeApi",
#   secret_key: "ft8TBDLTR8kFdU253xYhBxzX6aTyJK+dJKkGGUo8Ju8vPCgo5IEX590sh6OgY0s6"
