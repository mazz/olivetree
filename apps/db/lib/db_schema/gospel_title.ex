defmodule DB.Schema.GospelTitle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gospeltitles" do
    field :language_id, :string
    field :localizedname, :string
    field :uuid, Ecto.UUID
    field :gospel_id, :id

    # timestamps()
  end

  @doc false
  def changeset(gospel_title, attrs) do
    gospel_title
    |> cast(attrs, [:uuid, :localizedname, :language_id])
    |> validate_required([:uuid, :localizedname, :language_id])
  end
end
