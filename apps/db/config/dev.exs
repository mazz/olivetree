use Mix.Config

# Configure your database
config :db, DB.Repo,
  username: "postgres",
  password: "postgres",
  database: "olivetree_dev",
  hostname: "localhost"

# Configure file upload
config :arc, storage: Arc.Storage.Local, asset_host: "http://localhost:4000"
