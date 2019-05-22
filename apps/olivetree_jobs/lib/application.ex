defmodule Olivetree.Jobs.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Scheduler for all CRON jobs
      worker(Olivetree.Jobs.Scheduler, []),
      # Jobs
      # worker(Olivetree.Jobs.Reputation, []),
      # worker(Olivetree.Jobs.Flags, []),
      worker(Olivetree.Jobs.MetadataFetch, [])
    ]

    opts = [strategy: :one_for_one, name: Olivetree.Jobs.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Get app's version from `mix.exs`
  """
  def version() do
    case :application.get_key(:olivetree, :vsn) do
      {:ok, version} -> to_string(version)
      _ -> "unknown"
    end
  end
end
