defmodule DB.Repo.Migrations.PlaylistTitles do
  use Ecto.Migration

  def change do
    create table(:playlist_titles, primary_key: true) do
      add :uuid, :uuid
      add :localizedname, :string
      add :language_id, :string
      add :playlist_id, references(:playlists, on_delete: :nothing)
      timestamps(type: :utc_datetime)
    end
    create index(:playlist_titles, [:playlist_id])

    flush()
  end
end
