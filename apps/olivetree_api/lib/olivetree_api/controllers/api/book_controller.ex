defmodule OlivetreeApi.BookController do
  use OlivetreeApi, :controller

  alias OlivetreeApi.ErrorView
  alias OlivetreeApi.BookV13View
  alias OlivetreeApi.BookV12View
  alias OlivetreeApi.V12
  alias OlivetreeApi.V13

  require Logger
  require Ecto.Query

  action_fallback OlivetreeApi.FallbackController

  def indexv12(conn, %{"language-id" => lang}) do
    Logger.debug("lang #{inspect %{attributes: lang}}")

    V12.books_by_language(lang)
    |> case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      book_v12 ->
        conn
        |> put_view(BookV12View)
        |> render("indexv12.json", %{book_v12: book_v12})
    end
  end

  def indexv13(conn, %{"language-id" => lang, "offset" => offset, "limit" => limit}) do
    V13.books_by_language(lang, offset, limit)
    |> case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      book_v13 ->
        # Logger.debug("books #{inspect %{attributes: books}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            conn
            |> put_view(BookV13View)
            |> render("indexv13.json", %{book_v13: book_v13, api_version: api_version})
        end
    end
  end
end
