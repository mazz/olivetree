defmodule DB.Repo.Migrations.CreateClientdevice do
  use Ecto.Migration

  def change do
    create table(:clientdevices) do

      add :uuid, :uuid
      add :firebase_token, :string
      add :apns_token, :string
      add :preferred_language, :string
      add :user_agent, :string
      add :user_version, :string
      # timestamps()
    end

  end
end
