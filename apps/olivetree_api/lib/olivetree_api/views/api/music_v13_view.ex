defmodule OlivetreeApi.MusicV13View do
  use OlivetreeApi, :view
  alias OlivetreeApi.MusicV13View

  def render("indexv13.json", %{music_v13: music_v13, api_version: api_version}) do
    %{result: render_many(music_v13, MusicV13View, "music_v13.json"),
    pageNumber: music_v13.page_number,
    pageSize: music_v13.page_size,
    status: "success",
    totalEntries: music_v13.total_entries,
    totalPages: music_v13.total_pages,
    version: api_version}
  end

  def render("show.json", %{music_v13: music_v13}) do
    %{data: render_one(music_v13, MusicV13View, "music_v13.json")}
  end

  def render("music_v13.json", %{music_v13: music_v13}) do
    %{title: music_v13.title,
    localizedTitle: music_v13.localizedTitle,
    uuid: music_v13.uuid,
    languageId: music_v13.languageId}
  end
end
# %{music_v13: music_v13, api_version: api_version}
