defmodule OlivetreeApi.VideoView do
  use OlivetreeApi, :view

  def render("index.json", %{videos: videos}) do
    render_many(videos, OlivetreeApi.VideoView, "video.json")
  end

  def render("show.json", %{video: video}) do
    render_one(video, OlivetreeApi.VideoView, "video.json")
  end

  def render("video.json", %{video: video}) do
    %{
      id: video.id,
      hash_id: video.hash_id,
      title: video.title,
      provider: "youtube",
      provider_id: video.youtube_id,
      youtube_id: video.youtube_id,
      youtube_offset: video.youtube_offset,
      url: DB.Schema.Video.build_url(video),
      posted_at: video.inserted_at,
      speakers: render_many(video.speakers, OlivetreeApi.SpeakerView, "speaker.json"),
      language: video.language,
      is_partner: video.is_partner,
      unlisted: video.unlisted
    }
  end
end
