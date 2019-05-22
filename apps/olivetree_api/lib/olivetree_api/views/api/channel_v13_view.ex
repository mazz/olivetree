defmodule OlivetreeApi.ChannelV13View do
  use OlivetreeApi, :view
  alias OlivetreeApi.ChannelV13View

  require Logger

  def render("channelsv13.json", %{channel_v13: channel_v13, api_version: api_version}) do
    %{result: render_many(channel_v13, ChannelV13View, "channel_v13.json"),
    pageNumber: channel_v13.page_number,
    pageSize: channel_v13.page_size,
    status: "success",
    totalEntries: channel_v13.total_entries,
    totalPages: channel_v13.total_pages,
    version: api_version}
  end

  def render("show.json", %{channel_v13: channel_v13}) do
    %{data: render_one(channel_v13, ChannelV13View, "channel_v13.json")}
  end

  def render("channel_v13.json", %{channel_v13: channel_v13}) do
    Logger.debug("channel #{inspect %{attributes: channel_v13}}")

    %{basename: channel_v13.basename,
      uuid: channel_v13.uuid,
      orgUuid: channel_v13.org_uuid,
      ordinal: channel_v13.ordinal,
      smallThumbnailPath: channel_v13.small_thumbnail_path,
      medThumbnailPath: channel_v13.med_thumbnail_path,
      largeThumbnailPath: channel_v13.large_thumbnail_path,
      bannerPath: channel_v13.banner_path,
      hashId: channel_v13.hash_id,
      insertedAt: channel_v13.inserted_at |> render_unix_timestamp(),
      updatedAt: channel_v13.updated_at |> render_unix_timestamp()
    }
  end

  defp render_unix_timestamp(nil), do: nil
  defp render_unix_timestamp(datetime), do: DateTime.to_unix(datetime, :second)

end

