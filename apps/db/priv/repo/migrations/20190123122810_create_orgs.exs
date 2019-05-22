defmodule DB.Repo.Migrations.CreateOrgs do
  use Ecto.Migration

  def change do
    create table(:orgs, primary_key: true) do

      add :uuid, :uuid
      add :small_thumbnail_path, :string
      add :med_thumbnail_path, :string
      add :large_thumbnail_path, :string
      add :banner_path, :string
      add :basename, :string
      # A size of 10 allows us to go up to 100_000_000_000_000 media items
      add(:hash_id, :string, size: 12)

      timestamps(type: :utc_datetime)

      # timestamps()
    end

    # Create unique index on hash_id
    create(unique_index(:orgs, [:hash_id]))

    flush()
  end
end
