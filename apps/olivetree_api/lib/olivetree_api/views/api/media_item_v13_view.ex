defmodule OlivetreeApi.MediaItemV13View do
  use OlivetreeApi, :view
  alias OlivetreeApi.MediaItemV13View

  def render("indexv13.json",%{media_item_v13: media_item_v13, api_version: api_version}) do
    %{result: render_many(media_item_v13, MediaItemV13View, "media_item_v13.json"),
    pageNumber: media_item_v13.page_number,
    pageSize: media_item_v13.page_size,
    status: "success",
    totalEntries: media_item_v13.total_entries,
    totalPages: media_item_v13.total_pages,
    version: api_version}
    # %{data: render_many(media_item_v13, MediaItemV13View, "media_item_v13.json")}
  end

  def render("show.json", %{media_item_v13: media_item_v13}) do
    %{data: render_one(media_item_v13, MediaItemV13View, "media_item_v13.json")}
  end

  def render("media_item_v13.json", %{media_item_v13: media_item_v13}) do
    %{ordinal: media_item_v13.ordinal,
      uuid: media_item_v13.uuid,
      trackNumber: media_item_v13.track_number,
      medium: media_item_v13.medium,
      localizedname: media_item_v13.localizedname,
      path: media_item_v13.path,
      contentProviderLink: media_item_v13.content_provider_link,
      ipfsLink: media_item_v13.ipfs_link,
      languageId: media_item_v13.language_id,
      presenterName: media_item_v13.presenter_name,
      sourceMaterial: media_item_v13.source_material,
      playlistUuid: media_item_v13.playlist_uuid,
      tags: media_item_v13.tags,
      smallThumbnailPath: media_item_v13.small_thumbnail_path,
      medThumbnailPath: media_item_v13.med_thumbnail_path,
      largeThumbnailPath: media_item_v13.large_thumbnail_path,
      hashId: media_item_v13.hash_id,
      insertedAt: media_item_v13.inserted_at |> render_unix_timestamp(),
      updatedAt: media_item_v13.updated_at |> render_unix_timestamp(),
      mediaCategory: media_item_v13.media_category,
      presentedAt: media_item_v13.presented_at |> render_unix_timestamp(),
      publishedAt: media_item_v13.published_at |> render_unix_timestamp()
    }
  end

  defp render_unix_timestamp(nil), do: nil
  defp render_unix_timestamp(datetime), do: DateTime.to_unix(datetime, :second)

end
