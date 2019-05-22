# Since configuration is shared in umbrella projects, this file
# should only configure the :olivetree_api application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :olivetree_api,
  ecto_repos: [DB.Repo],
  generators: [context_app: :db, binary_id: true]

config :olivetree_api,
  cors_origins: "*"
  # cors_origins: []

# Configures the endpoint
config :olivetree_api, OlivetreeApi.Endpoint,
  # url: [host: "api.olivetree.app"],
  check_origin: ["//localhost", "//api.olivetree.app"],
  secret_key_base: "QI+125cFBB5Z+vR6D3ULCuhDalvbkd7Gse5zkpLrjhSK7sdm8XeNeB/Gq1zO5Gt8",
  render_errors: [view: OlivetreeApi.ErrorView, accepts: ~w(html json)],
  pubsub: [name: OlivetreeApi.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "KbeDjtwqHvOg4RGpnnLTEAEZ0raM2+5N3JbN5d2pCfnOSJ2Ir9+SJUlaApGvT1ej"]

config :olivetree_api, OlivetreeApi.Guardian,
  issuer: "OlivetreeApi",
  secret_key: "ft8TBDLTR8kFdU253xYhBxzX6aTyJK+dJKkGGUo8Ju8vPCgo5IEX590sh6OgY0s6"


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
