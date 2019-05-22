# Since configuration is shared in umbrella projects, this file
# should only configure the :olivetree application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

dev_secret = "8C6FsJwjV11d+1WPUIbkEH6gB/VavJrcXWoPLujgpclfxjkLkoNFSjVU9XfeNm6s"

# Configure your database
config :olivetree, DB.Repo,
  database: "olivetree_dev",
  pool_size: 10

# config :olivetree, Olivetree.Mailer,
#   adapter: Bamboo.MailgunAdapter,
#   api_key: "key-6-lwae88m8q5gefyfzuv-k1j33f05666",
#   domain: "sandbox30725.mailgun.org"
# Mails
config :olivetree, Olivetree.Mailer, adapter: Bamboo.LocalAdapter

# config :olivetree, OlivetreeApi.Auth.Guardian,
#   secret_key: "pnggot8GyQJKcPpPpnt1hZ1iGO9MZWkBd09+T6aJOQ2lK3ao6AnNgk0sCbydY8dW",
#   issuer: "OlivetreeApi"

# General config
config :olivetree,
  frontend_url: "http://localhost:3333/",
  oauth: [
    facebook: [
      client_id: "client_id",
      client_secret: "client_secret",
      redirect_uri: "http://localhost:3333/login/callback/facebook"
    ]
  ]

# Guardian
config :olivetree,
       Olivetree.Authenticator.GuardianImpl,
       secret_key: dev_secret


# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

