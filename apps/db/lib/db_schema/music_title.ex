defmodule DB.Schema.MusicTitle do
  use Ecto.Schema
  import Ecto.Changeset


  schema "musictitles" do
    field :language_id, :string
    field :localizedname, :string
    field :uuid, Ecto.UUID
    field :music_id, :id

    # timestamps()
  end

  @doc false
  def changeset(music_title, attrs) do
    music_title
    |> cast(attrs, [:uuid, :localizedname, :language_id])
    |> validate_required([:uuid, :localizedname, :language_id])
  end
end
