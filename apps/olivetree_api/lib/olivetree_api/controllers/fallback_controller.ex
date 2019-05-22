defmodule OlivetreeApi.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use OlivetreeApi, :controller

  alias Olivetree.Accounts.UserPermissions.PermissionsError

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(OlivetreeApi.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(404)
    |> render(OlivetreeApi.ErrorView, "error.json", message: "not_found")
  end

  def call(conn, {:error, %PermissionsError{}}) do
    conn
    |> put_status(403)
    |> render(OlivetreeApi.ErrorView, :"403")
  end
end
