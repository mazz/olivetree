defmodule DB.Schema.LanguageIdentifier do
  use Ecto.Schema
  import Ecto.Changeset

  schema "languageidentifiers" do
    field :identifier, :string
    field :source_material, :string
    field :supported, :boolean, default: false
    field :uuid, Ecto.UUID

    # timestamps()
  end

  @doc false
  def changeset(language_identifier, attrs) do
    language_identifier
    |> cast(attrs, [:uuid, :identifier, :source_material, :supported])
    |> validate_required([:uuid, :identifier, :source_material, :supported])
  end
end
