defmodule DB.Schema.AppVersion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "appversions" do
    field :android_supported, :boolean, default: false
    field :ios_supported, :boolean, default: false
    field :web_supported, :boolean, default: false
    field :uuid, Ecto.UUID
    field :version_number, :string


    # timestamps()
  end

  @doc false
  def changeset(app_version, attrs) do
    app_version
    |> cast(attrs, [:uuid, :version_number, :ios_supported, :android_supported, :web_supported])
    |> validate_required([:uuid, :version_number, :ios_supported, :android_supported, :web_supported])
  end
end
