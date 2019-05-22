defmodule DB.Schema.PushMessage do
  use Ecto.Schema
  import Ecto.Changeset


  schema "pushmessage" do
    field :created_at, :utc_datetime
    field :message, :string, size: 4096
    field :sent, :boolean, default: false
    field :title, :string
    field :updated_at, :utc_datetime
    field :uuid, Ecto.UUID

    # timestamps()
  end

  @doc false
  def changeset(push_message, attrs) do
    push_message
    |> cast(attrs, [:uuid, :created_at, :updated_at, :title, :message, :sent])
    |> validate_required([:uuid, :created_at, :updated_at, :title, :message, :sent])
  end
end
