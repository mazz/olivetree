defmodule OlivetreeApi.MusicTitleView do
  use OlivetreeApi, :view
  alias OlivetreeApi.MusicTitleView

  def render("index.json", %{musictitle: musictitle}) do
    %{data: render_many(musictitle, MusicTitleView, "music_title.json")}
  end

  def render("show.json", %{music_title: music_title}) do
    %{data: render_one(music_title, MusicTitleView, "music_title.json")}
  end

  def render("music_title.json", %{music_title: music_title}) do
    %{id: music_title.id,
      uuid: music_title.uuid,
      localizedname: music_title.localizedname,
      language_id: music_title.language_id}
  end
end
