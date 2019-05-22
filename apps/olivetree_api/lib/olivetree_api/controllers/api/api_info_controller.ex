defmodule OlivetreeApi.ApiInfoController do
  use OlivetreeApi, :controller

  def get(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{
      status: "✔",
      version: Olivetree.Application.version(),
      db_version: DB.Application.version()
    })
  end
end
