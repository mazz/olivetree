defmodule DB.Repo.Migrations.CreatePushmessage do
  use Ecto.Migration

  def change do
    create table(:pushmessages) do

      add :uuid, :uuid
      # add :created_at, :utc_datetime
      # add :updated_at, :utc_datetime
      add :title, :string
      add :message, :string, size: 4096
      add :sent, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end

  end
end
