defmodule OlivetreeApi.MusicV12View do
  use OlivetreeApi, :view
  alias OlivetreeApi.MusicV12View

  def render("indexv12.json", %{music_v12: music_v12}) do
    %{result: render_many(music_v12, MusicV12View, "music_v12.json"),
    status: "success",
    version: "1.2"}  end

  def render("show.json", %{music_v12: music_v12}) do
    %{data: render_one(music_v12, MusicV12View, "music_v12.json")}
  end

  def render("music_v12.json", %{music_v12: music_v12}) do
    %{mid: music_v12.mid,
      title: music_v12.title}
  end
end

