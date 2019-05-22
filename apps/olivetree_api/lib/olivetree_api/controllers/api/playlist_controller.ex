defmodule OlivetreeApi.PlaylistController do
  use OlivetreeApi, :controller

  alias OlivetreeApi.V13
  alias OlivetreeApi.ErrorView
  alias OlivetreeApi.PlaylistV13View

  require Logger

  action_fallback OlivetreeApi.FallbackController

  def indexv13(conn, _params = %{"uuid" => uuid_str, "language-id" => language_id, "offset" => offset, "limit" => limit}) do
    V13.playlists_by_channel_uuid(uuid_str, language_id, offset, limit)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      playlist_v13 ->
        Logger.debug("playlist_v13 #{inspect %{attributes: playlist_v13}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            conn
            |> put_view(PlaylistV13View)
            |> render("indexv13.json", %{playlist_v13: playlist_v13, api_version: api_version})
        end
      end
  end

end
