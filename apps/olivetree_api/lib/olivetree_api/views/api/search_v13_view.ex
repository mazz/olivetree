defmodule OlivetreeApi.SearchV13View do
  use OlivetreeApi, :view
  alias OlivetreeApi.SearchV13View

  def render("searchv13.json", %{search_v13: search_v13, api_version: api_version}) do
    %{result: render_many(search_v13, SearchV13View, "search_v13.json"),
    pageNumber: search_v13.page_number,
    pageSize: search_v13.page_size,
    status: "success",
    totalEntries: search_v13.total_entries,
    totalPages: search_v13.total_pages,
    version: api_version}

    # %{data: render_many(search_v13, SearchV13View, "search_v13.json")}
  end

  def render("show.json", %{search_v13: search_v13}) do
    %{data: render_one(search_v13, SearchV13View, "search_v13.json")}
  end

  def render("search_v13.json", %{search_v13: search_v13}) do
    %{ordinal: search_v13.ordinal,
      uuid: search_v13.uuid,
      trackNumber: search_v13.track_number,
      medium: search_v13.medium,
      localizedname: search_v13.localizedname,
      path: search_v13.path,
      contentProviderLink: search_v13.content_provider_link,
      ipfsLink: search_v13.ipfs_link,
      languageId: search_v13.language_id,
      presenterName: search_v13.presenter_name,
      sourceMaterial: search_v13.source_material,
      # playlistUuid: search_v13.playlist_uuid,
      tags: search_v13.tags,
      smallThumbnailPath: search_v13.small_thumbnail_path,
      medThumbnailPath: search_v13.med_thumbnail_path,
      largeThumbnailPath: search_v13.large_thumbnail_path,
      insertedAt: search_v13.inserted_at |> render_unix_timestamp(),
      updatedAt: search_v13.updated_at |> render_unix_timestamp(),
      mediaCategory: search_v13.media_category,
      presentedAt: search_v13.presented_at |> render_unix_timestamp(),
      publishedAt: search_v13.published_at |> render_unix_timestamp()
    }
  end

  defp render_unix_timestamp(nil), do: nil
  defp render_unix_timestamp(datetime), do: DateTime.to_unix(datetime, :second)

end
