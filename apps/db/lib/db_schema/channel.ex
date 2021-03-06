defmodule DB.Schema.Channel do
  use Ecto.Schema
  import Ecto.Changeset
  alias DB.Type.ChannelHashId

  schema "channels" do
    field :basename, :string
    field :ordinal, :integer
    field :small_thumbnail_path, :string
    field :med_thumbnail_path, :string
    field :large_thumbnail_path, :string
    field :banner_path, :string
    field :uuid, Ecto.UUID
    field :org_id, :integer
    field :hash_id, :string

    timestamps(type: :utc_datetime)

    # timestamps()
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:uuid, :ordinal, :basename, :large_thumbnail_path, :med_thumbnail_path, :small_thumbnail_path, :banner_path])
    |> validate_required([:uuid, :ordinal, :basename, :large_thumbnail_path, :med_thumbnail_path, :small_thumbnail_path, :banner_path])
  end



    @doc """
  Generate hash ID for channels

  ## Examples

      iex> DB.Schema.MediaItem.changeset_generate_hash_id(%DB.Schema.Video{id: 42, hash_id: nil})
      #Ecto.Changeset<action: nil, changes: %{hash_id: \"4VyJ\"}, errors: [], data: #DB.Schema.Video<>, valid?: true>
  """
  def changeset_generate_hash_id(channel) do
    change(channel, hash_id: ChannelHashId.encode(channel.id))
  end

end
