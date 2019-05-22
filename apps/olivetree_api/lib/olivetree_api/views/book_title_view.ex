defmodule OlivetreeApi.BookTitleView do
  use OlivetreeApi, :view
  alias OlivetreeApi.BookTitleView

  # def render("index.json", %{media: media, api_version: api_version}) do

  def render("index.json", %{booktitle: booktitle, api_version: api_version}) do
    %{data: render_many(booktitle, BookTitleView, "book_title.json")}
  end

  def render("show.json", %{book_title: book_title}) do
    %{data: render_one(book_title, BookTitleView, "book_title.json")}
  end

  def render("book_title.json", %{book_title: book_title}) do
    %{id: book_title.id,
      uuid: book_title.uuid,
      localizedname: book_title.localizedname,
      language_id: book_title.language_id}
  end
end
