defmodule OlivetreeApi.ChapterView do
  use OlivetreeApi, :view
  alias OlivetreeApi.ChapterView

  def render("index.json", %{chapter: chapter}) do
    %{data: render_many(chapter, ChapterView, "chapter.json")}
  end

  def render("show.json", %{chapter: chapter}) do
    %{data: render_one(chapter, ChapterView, "chapter.json")}
  end

  def render("chapter.json", %{chapter: chapter}) do
    %{id: chapter.id,
      absolute_id: chapter.absolute_id,
      uuid: chapter.uuid,
      basename: chapter.basename}
  end
end
