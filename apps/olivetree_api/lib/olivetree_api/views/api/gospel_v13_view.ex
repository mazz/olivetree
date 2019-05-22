defmodule OlivetreeApi.GospelV13View do
  use OlivetreeApi, :view
  alias OlivetreeApi.GospelV13View


  def render("indexv13.json", %{gospel_v13: gospel_v13, api_version: api_version}) do
    %{result: render_many(gospel_v13, GospelV13View, "gospel_v13.json"),
    pageNumber: gospel_v13.page_number,
    pageSize: gospel_v13.page_size,
    status: "success",
    totalEntries: gospel_v13.total_entries,
    totalPages: gospel_v13.total_pages,
    version: api_version}
  end

  def render("show.json", %{gospel_v13: gospel_v13}) do
    %{data: render_one(gospel_v13, GospelV13View, "gospel_v13.json")}
  end

  def render("gospel_v13.json", %{gospel_v13: gospel_v13}) do
    %{title: gospel_v13.title,
    localizedTitle: gospel_v13.localizedTitle,
    uuid: gospel_v13.uuid,
    languageId: gospel_v13.languageId}
  end
end
