defmodule DB.Repo.Migrations.CreateMediaitems do
  use Ecto.Migration

  def change do
    create table(:mediaitems, primary_key: true) do

      add :ordinal, :integer
      add :uuid, :uuid
      add :track_number, :integer
      add :medium, :string
      add :localizedname, :string
      add :path, :string
      add :small_thumbnail_path, :string
      add :med_thumbnail_path, :string
      add :large_thumbnail_path, :string
      add :content_provider_link, :string
      add :ipfs_link, :string
      add :language_id, :string
      add :presenter_name, :string
      add :source_material, :string
      add :tags, {:array, :string}
      add :media_category, DB.Type.MediaCategory.type()

      add :playlist_id, references(:playlists, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:mediaitems, [:playlist_id])
    create index(:mediaitems, ["updated_at DESC"])

    flush()
  end
end
