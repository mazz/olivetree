defmodule OlivetreeApi.MediaChapterController do
  use OlivetreeApi, :controller

  alias OlivetreeApi.V12
  alias OlivetreeApi.V13

  alias OlivetreeApi.ErrorView
  alias OlivetreeApi.MediaChapterV12View
  alias OlivetreeApi.MediaChapterV13View

  require Logger

  action_fallback OlivetreeApi.FallbackController

  def indexv12(conn, _params = %{"bid" => bid_str, "language-id" => language_id}) do
    V12.chapter_media_by_bid(bid_str, language_id)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      media_chapter_v12 ->
        Logger.debug("media_chapter_v12 #{inspect %{attributes: media_chapter_v12}}")
        conn
        |> put_view(MediaChapterV12View)
        |> render("indexv12.json", %{media_chapter_v12: media_chapter_v12})
      end
  end

  def indexv13(conn, _params = %{"uuid" => bid_str, "language-id" => language_id, "offset" => offset, "limit" => limit}) do
    V13.chapter_media_by_uuid(bid_str, language_id, offset, limit)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      media_chapter_v13 ->
        Logger.debug("media_chapter_v13 #{inspect %{attributes: media_chapter_v13}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            conn
            |> put_view(MediaChapterV13View)
            |> render("indexv13.json", %{media_chapter_v13: media_chapter_v13, api_version: api_version})
        end
      end
  end
end
