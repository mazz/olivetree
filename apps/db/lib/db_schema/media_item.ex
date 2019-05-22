defmodule DB.Schema.MediaItem do
  use Ecto.Schema
  import Ecto.Changeset
  alias DB.Type.MediaItemHashId


  schema "mediaitems" do
    field :content_provider_link, :string
    field :ipfs_link, :string
    field :language_id, :string
    field :localizedname, :string
    field :medium, :string
    field :ordinal, :integer
    field :path, :string
    field :presenter_name, :string
    field :presented_at, :utc_datetime
    field :small_thumbnail_path, :string
    field :med_thumbnail_path, :string
    field :large_thumbnail_path, :string
    field :source_material, :string
    field :track_number, :integer
    field :tags, {:array, :string}
    field :media_category, DB.Type.MediaCategory
    field :uuid, Ecto.UUID
    field :playlist_id, :integer
    field :org_id, :integer
    field :published_at, :utc_datetime, null: true
    field :hash_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(media_item, attrs) do
    media_item
    |> cast(attrs, [:ordinal, :uuid, :playlist_id, :org_id, :track_number, :tags, :media_category, :medium, :localizedname, :path, :small_thumbnail_path, :med_thumbnail_path, :large_thumbnail_path, :content_provider_link, :ipfs_link, :language_id, :presenter_name, :presented_at, :source_material])
    |> validate_required([:ordinal, :uuid, :playlist_id, :org_id, :track_number, :tags, :media_category, :medium, :localizedname, :path, :small_thumbnail_path, :med_thumbnail_path, :large_thumbnail_path, :content_provider_link, :ipfs_link, :language_id, :presenter_name, :presented_at, :source_material])
  end

    @doc """
  Generate hash ID for media items

  ## Examples

      iex> DB.Schema.MediaItem.changeset_generate_hash_id(%DB.Schema.Video{id: 42, hash_id: nil})
      #Ecto.Changeset<action: nil, changes: %{hash_id: \"4VyJ\"}, errors: [], data: #DB.Schema.Video<>, valid?: true>
  """
  def changeset_generate_hash_id(media_item) do
    change(media_item, hash_id: MediaItemHashId.encode(media_item.id))
  end

end
