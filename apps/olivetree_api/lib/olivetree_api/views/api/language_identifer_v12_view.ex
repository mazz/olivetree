defmodule OlivetreeApi.LanguageIdentifierV12View do
  use OlivetreeApi, :view
  alias OlivetreeApi.LanguageIdentifierV12View

  def render("indexv12.json",%{language_identifier_v12: language_identifier_v12}) do
    %{result: render_many(language_identifier_v12, LanguageIdentifierV12View, "language_identifier_v12.json"),
    status: "success",
    version: "1.2"}
    # %{data: render_many(language_identifier_v12, LanguageIdentifierV12View, "language_identifier_v12.json")}
  end

  def render("show.json", %{language_identifier_v12: language_identifier_v12}) do
    %{data: render_one(language_identifier_v12, LanguageIdentifierV12View, "language_identifier_v12.json")}
  end

  def render("language_identifier_v12.json", %{language_identifier_v12: language_identifier_v12}) do
    %{languageIdentifier: language_identifier_v12.identifier, sourceMaterial: language_identifier_v12.source_material, supported: language_identifier_v12.supported}
  end
end
