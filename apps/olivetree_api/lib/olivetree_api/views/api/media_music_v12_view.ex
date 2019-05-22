defmodule OlivetreeApi.MediaMusicV12View do
  use OlivetreeApi, :view
  alias OlivetreeApi.MediaMusicV12View

  def render("indexv12.json",%{media_music_v12: media_music_v12}) do
    %{result: render_many(media_music_v12, MediaMusicV12View, "media_music_v12.json"),
    status: "success",
    version: "1.2"}
    # %{data: render_many(media_music_v12, MediaMusicV12View, "media_music_v12.json")}
  end

  def render("show.json", %{media_music_v12: media_music_v12}) do
    %{data: render_one(media_music_v12, MediaMusicV12View, "media_music_v12.json")}
  end

  def render("media_music_v12.json", %{media_music_v12: media_music_v12}) do
    %{localizedName: media_music_v12.localizedName, path: media_music_v12.path, presenterName: media_music_v12.presenterName, sourceMaterial: media_music_v12.sourceMaterial, uuid: media_music_v12.uuid}
  end


end
