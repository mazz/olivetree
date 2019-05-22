use Mix.Config

config :logger,
  level: :debug,
  backends: [:console],
  compile_time_purge_level: :debug

# Configure file upload
config :arc, storage: Arc.Storage.Local

# Configure your database
# config :db, DB.Repo,
#   hostname:
#     if(
#       is_nil(System.get_env("CF_DB_HOSTNAME")),
#       do: "localhost",
#       else: System.get_env("CF_DB_HOSTNAME")
#     ),
#   username: "postgres",
#   password: "postgres",
#   database: "captain_fact_test",
#   pool: Ecto.Adapters.SQL.Sandbox
