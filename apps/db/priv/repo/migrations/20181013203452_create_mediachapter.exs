defmodule DB.Repo.Migrations.CreateMediachapter do
  use Ecto.Migration

  def change do
    create table(:mediachapters) do
      add :absolute_id, :integer
      add :uuid, :uuid
      add :track_number, :integer
      add :localizedname, :string
      add :path, :string
      add :large_thumbnail_path, :string
      add :small_thumbnail_path, :string
      add :language_id, :string
      add :presenter_name, :string
      add :source_material, :string
      add :chapter_id, references(:chapters, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:mediachapters, [:chapter_id])
  end
end
