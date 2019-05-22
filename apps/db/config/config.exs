use Mix.Config

# General application configuration
config :db,
  env: Mix.env(),
  adapter: Ecto.Adapters.Postgres,
  ecto_repos: [DB.Repo]

# Database: use postgres
config :db, DB.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool_size: 3,
  database: "olivetree_dev",
  pool: Ecto.Adapters.SQL.Sandbox

# Import environment specific config
import_config "#{Mix.env()}.exs"

