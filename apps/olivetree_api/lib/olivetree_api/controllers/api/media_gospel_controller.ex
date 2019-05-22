defmodule OlivetreeApi.MediaGospelController do
  use OlivetreeApi, :controller

  alias OlivetreeApi.V12
  alias OlivetreeApi.V13

  alias OlivetreeApi.ErrorView
  alias OlivetreeApi.MediaGospelV12View
  alias OlivetreeApi.MediaGospelV13View

  require Logger

  action_fallback OlivetreeApi.FallbackController

  def indexv12(conn, params = %{"gid" => gid_str}) do
    V12.gospel_media_by_gid(gid_str)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render(ErrorView, "403.json", %{message: "language not found in supported list."})
      media_gospel_v12 ->
        Logger.debug("media_gospel_v12 #{inspect %{attributes: media_gospel_v12}}")
        conn
        |> put_view(MediaGospelV12View)
        |> render("indexv12.json", %{media_gospel_v12: media_gospel_v12})
      end
  end

  def indexv13(conn, params = %{"uuid" => gid_str, "offset" => offset, "limit" => limit}) do
    V13.gospel_media_by_uuid(gid_str, offset, limit)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      media_gospel_v13 ->
        Logger.debug("media_gospel_v13 #{inspect %{attributes: media_gospel_v13}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            conn
            |> put_view(MediaGospelV13View)
            |> render("indexv13.json", %{media_gospel_v13: media_gospel_v13, api_version: api_version})
        end
      end
  end

end
