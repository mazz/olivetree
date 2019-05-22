use Mix.Config

config :logger,
  level: :debug,
  backends: [:console],
  compile_time_purge_level: :debug

# Disable CRON tasks on test
config :olivetree_jobs, Olivetree.Jobs.Scheduler, jobs: []
