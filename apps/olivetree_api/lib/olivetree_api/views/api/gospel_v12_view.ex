defmodule OlivetreeApi.GospelV12View do
  use OlivetreeApi, :view
  alias OlivetreeApi.GospelV12View

  def render("indexv12.json", %{gospel_v12: gospel_v12}) do
    %{result: render_many(gospel_v12, GospelV12View, "gospel_v12.json"),
      status: "success",
      version: "1.2"}
  end

  def render("show.json", %{gospel_v12: gospel_v12}) do
    %{data: render_one(gospel_v12, GospelV12View, "gospel_v12.json")}
  end

  def render("gospel_v12.json", %{gospel_v12: gospel_v12}) do
    %{title: gospel_v12.title,
    localizedTitle: gospel_v12.localizedTitle,
    gid: gospel_v12.uuid,
    languageId: gospel_v12.languageId}
  end
end

