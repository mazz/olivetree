defmodule OlivetreeApi.LanguageIdentifierController do
  use OlivetreeApi, :controller

  alias OlivetreeApi.V12
  alias OlivetreeApi.V13

  alias OlivetreeApi.ErrorView
  alias OlivetreeApi.LanguageIdentifierV12View
  alias OlivetreeApi.LanguageIdentifierV13View

  require Logger

  action_fallback OlivetreeApi.FallbackController

  def indexv12(conn, _params) do
    V12.language_identifiers()
    |> case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      language_identifier_v12 ->
        Logger.debug("language_identifier_v12 #{inspect %{attributes: language_identifier_v12}}")
        conn
        |> put_view(LanguageIdentifierV12View)
        |> render("indexv12.json", %{language_identifier_v12: language_identifier_v12})
    end
  end
  def indexv13(conn,  %{"offset" => offset, "limit" => limit}) do
    V13.language_identifiers(offset, limit)
    |>
    case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      language_identifier_v13 ->
        Logger.debug("language_identifier_v13 #{inspect %{attributes: language_identifier_v13}}")
        Enum.at(conn.path_info, 0)
        |>
        case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            conn
            |> put_view(LanguageIdentifierV13View)
            |> render("indexv13.json", %{language_identifier_v13: language_identifier_v13, api_version: api_version})
        end
    end
  end
end
