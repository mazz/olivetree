# Since configuration is shared in umbrella projects, this file
# should only configure the :olivetree application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :olivetree, DB.Repo,
  database: "olivetree_test",
  pool: Ecto.Adapters.SQL.Sandbox

config :olivetree, Olivetree.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: "key-6-lwae88m8q5gefyfzuv-k1j33f05666",
  domain: "sandbox30725.mailgun.org"

config :logger,
  level: :debug,
  backends: [:console],
  compile_time_purge_level: :debug

# config :olivetree, OlivetreeApi.Auth.Guardian,
#   secret_key: "pnggot8GyQJKcPpPpnt1hZ1iGO9MZWkBd09+T6aJOQ2lK3ao6AnNgk0sCbydY8dW",
#   issuer: "OlivetreeApi"
