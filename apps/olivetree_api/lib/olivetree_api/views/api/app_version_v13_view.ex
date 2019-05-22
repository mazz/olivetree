defmodule OlivetreeApi. AppVersionV13View do
  use OlivetreeApi, :view
  alias OlivetreeApi. AppVersionV13View

  def render("indexv13.json", %{app_version_v13: app_version_v13, api_version: api_version}) do
    %{result: render_many(app_version_v13,  AppVersionV13View, "app_version_v13.json"),
    pageNumber: app_version_v13.page_number,
    pageSize: app_version_v13.page_size,
    status: "success",
    totalEntries: app_version_v13.total_entries,
    totalPages: app_version_v13.total_pages,
    version: api_version}
  end

  def render("show.json", %{app_version_v13: app_version_v13}) do
    %{data: render_one(app_version_v13,  AppVersionV13View, "app_version_v13.json")}
  end

  def render("app_version_v13.json", %{app_version_v13: app_version_v13}) do
    %{uuid: app_version_v13.uuid,
      versionNumber: app_version_v13.version_number,
      iosSupported: app_version_v13.ios_supported,
      androidSupported: app_version_v13.android_supported,
      webSupported: app_version_v13.web_supported,
    }
  end
end
