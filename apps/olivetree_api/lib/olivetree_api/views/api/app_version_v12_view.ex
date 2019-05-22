defmodule OlivetreeApi.AppVersionV12View do
  use OlivetreeApi, :view
  alias OlivetreeApi.AppVersionV12View

  def render("indexv12.json", %{app_version_v12: app_version_v12}) do
    %{data: render_many(app_version_v12, AppVersionV12View, "app_version_v12.json")}
  end

  def render("show.json", %{app_version_v12: app_version_v12}) do
    %{data: render_one(app_version_v12, AppVersionV12View, "app_version_v12.json")}
  end

  def render("app_version_v12.json", %{app_version_v12: app_version_v12}) do
    %{uuid: app_version_v12.uuid,
      versionNumber: app_version_v12.version_number,
      iosSupported: app_version_v12.ios_supported,
      androidSupported: app_version_v12.android_supported}
  end
end
