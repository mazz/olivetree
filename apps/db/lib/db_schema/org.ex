defmodule DB.Schema.Org do
  use Ecto.Schema
  import Ecto.Changeset
  alias DB.Type.OrgHashId


  schema "orgs" do
    field :basename, :string
    field :shortname, :string
    field :small_thumbnail_path, :string
    field :med_thumbnail_path, :string
    field :large_thumbnail_path, :string
    field :banner_path, :string
    field :uuid, Ecto.UUID
    field :hash_id, :string

    timestamps(type: :utc_datetime)

    # timestamps()
  end

    @doc """
  Generate hash ID for media items

  ## Examples

      iex> DB.Schema.MediaItem.changeset_generate_hash_id(%DB.Schema.Video{id: 42, hash_id: nil})
      #Ecto.Changeset<action: nil, changes: %{hash_id: \"4VyJ\"}, errors: [], data: #DB.Schema.Video<>, valid?: true>
  """
  def changeset_generate_hash_id(org) do
    change(org, hash_id: OrgHashId.encode(org.id))
  end

  @doc false
  def changeset(org, attrs) do
    org
    |> cast(attrs, [:uuid, :basename, :shortname, :large_thumbnail_path, :med_thumbnail_path, :small_thumbnail_path, :banner_path])
    |> validate_required([:uuid, :basename, :shortname, :large_thumbnail_path, :med_thumbnail_path, :small_thumbnail_path, :banner_path])
  end
end
