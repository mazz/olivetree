defmodule DB.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels, primary_key: true) do

      add :uuid, :uuid
      add :ordinal, :integer
      add :basename, :string
      add :small_thumbnail_path, :string
      add :med_thumbnail_path, :string
      add :large_thumbnail_path, :string
      add :banner_path, :string
      add :org_id, references(:orgs, on_delete: :delete_all)
      timestamps(type: :utc_datetime)

      # timestamps()
    end

    create index(:channels, [:org_id])

    flush()
  end
end
