defmodule OlivetreeApi.BookV13View do
  use OlivetreeApi, :view
  alias OlivetreeApi.BookV13View

  require Logger

  def render("indexv13.json", %{book_v13: book_v13, api_version: api_version}) do
    %{result: render_many(book_v13, BookV13View, "book_v13.json"),
    pageNumber: book_v13.page_number,
    pageSize: book_v13.page_size,
    status: "success",
    totalEntries: book_v13.total_entries,
    totalPages: book_v13.total_pages,
    version: api_version}
  end

  def render("show.json", %{book_v13: book_v13}) do
    %{data: render_one(book_v13, BookV13View, "book_v13.json")}
  end

  def render("book_v13.json", %{book_v13: book_v13}) do
    # {"Revelation", "Apocalipse", "2c22a08a-80ee-4ec1-be94-f018892fe8ba", "pt"}
    # {b.basename, title.localizedname, b.uuid, title.language_id}
    Logger.debug("book #{inspect %{attributes: book_v13}}")

    %{title: book_v13.title,
    localizedTitle: book_v13.localizedTitle,
    uuid: book_v13.uuid,
    languageId: book_v13.languageId}
  end
end
