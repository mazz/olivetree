# Since configuration is shared in umbrella projects, this file
# should only configure the :olivetree application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# ---- [Global config keys] ----

frontend_url = String.trim_trailing("http://localhost:3000/") <> "/"

# ---- [APP CONFIG] :olivetree ----

# TODO: add facebook keys
# TODO: add youtube_api_key keys

config :olivetree,
  env: Mix.env(),
  ecto_repos: [DB.Repo],
  frontend_url: frontend_url,
  invitation_system: false,
  youtube_api_key: "AIzaSyB01nsJz0y24aXMqbX34oJ9Y4ywh0koKe4", #fwsaved-web
  oauth: [
    facebook: [
      client_id: "client_id",
      client_secret: "client_secret",
      redirect_uri: Path.join(frontend_url, "login/callback/facebook")
    ]
  ]


# TODO: add ex_aws keys

config :ex_aws,
  access_key_id: ["access_key_id", :instance_role],
  secret_access_key: ["secret_access_key", :instance_role]

# TODO: add arc keys

config :arc,
  bucket: "s3_bucket"

config :olivetree, Olivetree.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: "key-6-lwae88m8q5gefyfzuv-k1j33f05666",
  domain: "sandbox30725.mailgun.org"

config :pigeon, :fcm,
  fcm_default: %{
    key: "AAAA7hc7NSo:APA91bFIP2n9IHrcBxitXcV8BWfdY_bb8BDEljEAh8o4EqUZZZWUNhEzi360upRcySV9gRVyL9kEoXSCUtCm9DZEyvE4JQbTSsN1n1ocCZ-lMOjD2e4M_J_u-ij05UI0o1pTh_dfzVd3"
  }

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# config :olivetree, OlivetreeApi.Auth.Guardian,
#   secret_key: "pnggot8GyQJKcPpPpnt1hZ1iGO9MZWkBd09+T6aJOQ2lK3ao6AnNgk0sCbydY8dW",
#   issuer: "OlivetreeApi"

config :olivetree, Olivetree.Authenticator.GuardianImpl,
  secret_key: "pnggot8GyQJKcPpPpnt1hZ1iGO9MZWkBd09+T6aJOQ2lK3ao6AnNgk0sCbydY8dW",
  issuer: "Olivetree",
  ttl: {30, :days},
  serializer: Olivetree.Accounts.GuardianSerializer,
  permissions: %{default: [:read, :write]}

config :olivetree,
  captions_fetcher: Olivetree.Videos.CaptionsFetcherYoutube

config :guardian, Guardian.DB, repo: DB.Repo

config :rollbax,
  enabled: true,
  access_token: "a68f30a241f64dddab0349d1f4375506",
  environment: "production"

import_config "#{Mix.env()}.exs"
