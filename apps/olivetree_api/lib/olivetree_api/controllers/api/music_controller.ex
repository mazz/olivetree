defmodule OlivetreeApi.MusicController do
  use OlivetreeApi, :controller

  alias OlivetreeApi.MusicV13View
  alias OlivetreeApi.MusicV12View
  alias OlivetreeApi.V12
  alias OlivetreeApi.V13

  require Logger

  action_fallback OlivetreeApi.FallbackController

  def indexv12(conn, _params) do
    V12.music()
    |> case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      music_v12 ->
        Logger.debug("music_v12 #{inspect %{attributes: music_v12}}")
        conn
        |> put_view(MusicV12View)
        |> render("indexv12.json", %{music_v12: music_v12})
    end
  end

  # def index(conn, %{"language-id" => lang}) do
  def indexv13(conn,  %{"language-id" => lang, "offset" => offset, "limit" => limit}) do
      Logger.debug("lang #{inspect %{attributes: lang}}")
    # IO.inspect(conn)
    V13.music_by_language(lang, offset, limit)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      music_v13 ->
        Logger.debug("music_v13 #{inspect %{attributes: music_v13}}")
        Enum.at(conn.path_info, 0)
        |>
        case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            conn
            |> put_view(MusicV13View)
            |> render("indexv13.json", %{music_v13: music_v13, api_version: api_version})
        end
    end
  end

end
