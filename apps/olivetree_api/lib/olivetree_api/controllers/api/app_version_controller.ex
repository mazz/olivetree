defmodule OlivetreeApi.AppVersionController do
  use OlivetreeApi, :controller

  alias OlivetreeApi.AppVersionV13View
  alias OlivetreeApi.AppVersionV12View
  alias OlivetreeApi.V12
  alias OlivetreeApi.V13

  require Logger

  action_fallback OlivetreeApi.FallbackController

  def indexv12(conn, _params) do
    V12.app_versions()
    |> case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      app_version_v12 ->
        Logger.debug("app_version_v12 #{inspect %{attributes: app_version_v12}}")
        conn
        |> put_view(AppVersionV12View)
        |> render("indexv12.json", %{app_version_v12: app_version_v12})
    end
  end

  def indexv13(conn,  %{"offset" => offset, "limit" => limit}) do
    V13.app_versions(offset, limit)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      app_version_v13 ->
        Logger.debug("app_version #{inspect %{attributes: app_version_v13}}")
        Enum.at(conn.path_info, 0)
        |>
        case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            conn
            |> put_view(AppVersionV13View)
            |> render("indexv13.json", %{app_version_v13: app_version_v13, api_version: api_version})
        end
    end
  end

end
