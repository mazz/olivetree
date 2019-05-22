defmodule OlivetreeApi.BookV12View do
  use OlivetreeApi, :view
  alias OlivetreeApi.BookV12View

  require Logger

  def render("indexv12.json", %{book_v12: book_v12}) do
    %{result: render_many(book_v12, BookV12View, "book_v12.json"),
      status: "success",
      version: "1.2"}
  end

  def render("show.json", %{book_v12: book_v12}) do
    %{data: render_one(book_v12, BookView, "book_v12.json")}
  end

  def render("book_v12.json", %{book_v12: book_v12}) do
    Logger.debug("book_v12 #{inspect %{attributes: book_v12}}")

    %{title: book_v12.title,
    localizedTitle: book_v12.localizedTitle,
    bid: book_v12.uuid,
    languageId: book_v12.languageId}
  end
end
