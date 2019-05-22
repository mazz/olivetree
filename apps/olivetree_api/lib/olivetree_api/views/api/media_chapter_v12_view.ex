defmodule OlivetreeApi.MediaChapterV12View do
  use OlivetreeApi, :view
  alias OlivetreeApi.MediaChapterV12View

  def render("indexv12.json", %{media_chapter_v12: media_chapter_v12}) do
    %{result: render_many(media_chapter_v12, MediaChapterV12View, "media_chapter_v12.json"),
    status: "success",
    version: "1.2"}

    # %{data: render_many(mediachapter, MediaChapterView, "media_chapter.json")}
  end

  def render("show.json", %{media_chapter_v12: media_chapter_v12}) do
    %{data: render_one(media_chapter_v12, MediaChapterV12View, "media_chapter_v12.json")}
  end

  def render("media_chapter_v12.json", %{media_chapter_v12: media_chapter_v12}) do
    %{localizedName: media_chapter_v12.localizedName, path: media_chapter_v12.path, presenterName: media_chapter_v12.presenterName, sourceMaterial: media_chapter_v12.sourceMaterial, uuid: media_chapter_v12.uuid}
  end
end
