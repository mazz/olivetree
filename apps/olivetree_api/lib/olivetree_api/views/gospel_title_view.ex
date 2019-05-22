defmodule OlivetreeApi.GospelTitleView do
  use OlivetreeApi, :view
  alias OlivetreeApi.GospelTitleView

  def render("index.json", %{gospeltitle: gospeltitle}) do
    %{data: render_many(gospeltitle, GospelTitleView, "gospel_title.json")}
  end

  def render("show.json", %{gospel_title: gospel_title}) do
    %{data: render_one(gospel_title, GospelTitleView, "gospel_title.json")}
  end

  def render("gospel_title.json", %{gospel_title: gospel_title}) do
    %{id: gospel_title.id,
      uuid: gospel_title.uuid,
      localizedname: gospel_title.localizedname,
      language_id: gospel_title.language_id}
  end
end
