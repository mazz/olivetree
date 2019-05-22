defmodule DB.Schema.Playlist do
  use Ecto.Schema
  import Ecto.Changeset
  alias DB.Type.PlaylistHashId

  schema "playlists" do
    # field :language_id, :string
    # field :localizedname, :string
    field :ordinal, :integer
    field :small_thumbnail_path, :string
    field :med_thumbnail_path, :string
    field :large_thumbnail_path, :string
    field :banner_path, :string
    field :uuid, Ecto.UUID
    field :channel_id, :integer
    field :media_category, DB.Type.MediaCategory
    field :hash_id, :string

    timestamps(type: :utc_datetime)


    # timestamps()
  end

  @doc false
  def changeset(playlist, attrs) do
    playlist
    |> cast(attrs, [:ordinal, :uuid, :large_thumbnail_path, :med_thumbnail_path, :small_thumbnail_path, :banner_path])
    |> validate_required([:ordinal, :uuid, :large_thumbnail_path, :med_thumbnail_path, :small_thumbnail_path, :banner_path])
  end


    @doc """
  Generate hash ID for media items

  ## Examples

      iex> DB.Schema.MediaItem.changeset_generate_hash_id(%DB.Schema.Video{id: 42, hash_id: nil})
      #Ecto.Changeset<action: nil, changes: %{hash_id: \"4VyJ\"}, errors: [], data: #DB.Schema.Video<>, valid?: true>
  """
  def changeset_generate_hash_id(playlist) do
    change(playlist, hash_id: PlaylistHashId.encode(playlist.id))
  end

end

