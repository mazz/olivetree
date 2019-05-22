defmodule Olivetree.Jobs.Scheduler do
  use Quantum.Scheduler, otp_app: :olivetree_jobs

  #  Scheduler (job runner) implementation. See `config/config.exs` to see the
  #  exact configuration with run intervals.
end
