defmodule OlivetreeApi.MediaMusicController do
  use OlivetreeApi, :controller

  alias OlivetreeApi.V12
  alias OlivetreeApi.V13

  alias OlivetreeApi.ErrorView
  alias OlivetreeApi.MediaMusicV12View
  alias OlivetreeApi.MediaMusicV13View

  require Logger

  action_fallback OlivetreeApi.FallbackController

  def indexv12(conn, _params = %{"mid" => mid_str}) do
    V12.music_media_by_mid(mid_str)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      media_music_v12 ->
        Logger.debug("media_music_v12 #{inspect %{attributes: media_music_v12}}")
        conn
        |> put_view(MediaMusicV12View)
        |> render("indexv12.json", %{media_music_v12: media_music_v12})
      end
  end

  def indexv13(conn, _params = %{"uuid" => gid_str, "offset" => offset, "limit" => limit}) do
    V13.music_media_by_uuid(gid_str, offset, limit)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      media_music_v13 ->
        Logger.debug("media_music_v13 #{inspect %{attributes: media_music_v13}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            conn
            |> put_view(MediaMusicV13View)
            |> render("indexv13.json", %{media_music_v13: media_music_v13, api_version: api_version})
        end
      end
  end
end
