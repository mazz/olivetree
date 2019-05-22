defmodule DB.Schema.ClientDevice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clientdevices" do
    field :apns_token, :string
    field :firebase_token, :string
    field :preferred_language, :string
    field :user_agent, :string
    field :user_version, :string
    field :uuid, Ecto.UUID

    # timestamps()
  end

  @doc false
  def changeset(client_device, attrs) do
    client_device
    |> cast(attrs, [:uuid, :firebase_token, :apns_token, :preferred_language, :user_agent, :user_version])
    |> validate_required([:uuid, :firebase_token, :apns_token, :preferred_language, :user_agent])
  end
end
