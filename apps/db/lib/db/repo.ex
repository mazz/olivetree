defmodule DB.Repo do
  use Ecto.Repo,
  otp_app: :db,
  adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 50
  def init(_type, config) do
    {:ok, Keyword.put(config, :url, System.get_env("DATABASE_URL"))}
  end
end
