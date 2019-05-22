defmodule OlivetreeApi.SearchController do
  use OlivetreeApi, :controller

  alias OlivetreeApi.V13
  alias OlivetreeApi.ErrorView
  alias OlivetreeApi.SearchV13View

  require Logger

  action_fallback OlivetreeApi.FallbackController


  def searchv13(conn,
  params = %{"query" => query_string,
    "offset" => offset,
    "limit" => limit
  }) do

    # optional params
    media_category = Map.get(params, "mediaCategory", nil)
    playlist_uuid = Map.get(params, "playlistUuid", nil)
    channel_uuid = Map.get(params, "channelUuid", nil)
    published_after = Map.get(params, "publishedAfter", nil)
    updated_after = Map.get(params, "updatedAfter", nil)
    presented_after = Map.get(params, "presentedAfter", nil)

    V13.search(query_string, offset, limit,
      media_category,
      playlist_uuid,
      channel_uuid,
      published_after,
      updated_after,
      presented_after
      )
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "something bad happened"})
      search_v13 ->
        Logger.debug("search_v13 #{inspect %{attributes: search_v13}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            conn
            |> put_view(SearchV13View)
            |> render("searchv13.json", %{search_v13: search_v13, api_version: api_version})
        end
      end
  end

end
