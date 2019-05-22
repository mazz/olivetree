defmodule OlivetreeApi.MediaItemController do
  use OlivetreeApi, :controller

  alias OlivetreeApi.V13

  alias OlivetreeApi.ErrorView
  alias OlivetreeApi.MediaItemV13View

  require Logger

  action_fallback OlivetreeApi.FallbackController

  def indexv13(conn, _params = %{"uuid" => playlist_uuid, "language-id" => language_id, "offset" => offset, "limit" => limit}) do
    V13.media_items_by_playlist_uuid(playlist_uuid, language_id, offset, limit)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "error retrieving media items."})
      media_item_v13 ->
        Logger.debug("media_item_v13 #{inspect %{attributes: media_item_v13}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            conn
            |> put_view(MediaItemV13View)
            |> render("indexv13.json", %{media_item_v13: media_item_v13, api_version: api_version})
        end
      end
  end
end
