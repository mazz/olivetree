use Mix.Config

# Configure scheduler
config :olivetree_jobs, Olivetree.Jobs.Scheduler,
  # Run only one instance across cluster
  global: true,
  debug_logging: false,
  jobs: [
    # credo:disable-for-lines:10
    # Actions analysers
    # Every minute
    # {{:extended, "*/20"}, {Olivetree.Jobs.Reputation, :update, []}},
    # Every day
    # {"@daily", {Olivetree.Jobs.Reputation, :reset_daily_limits, []}},
    # Every minute
    # {"*/1 * * * *", {Olivetree.Jobs.Flags, :update, []}},
    # Various updaters
    # Every 5 minutes
    # {"*/5 * * * *", {Olivetree.Jobs.Moderation, :update, []}}



    # {"*/1 * * * *", {Olivetree.Jobs.MetadataFetch, :update, []}},

  ]

# Configure Postgres pool size
config :db, DB.Repo, pool_size: 3

# Import environment specific config
import_config "#{Mix.env()}.exs"
