defmodule DB.Repo.Migrations.CreateMusictitle do
  use Ecto.Migration

  def change do
    create table(:musictitles) do

      add :uuid, :uuid
      add :localizedname, :string
      add :language_id, :string
      add :music_id, references(:music, on_delete: :nothing)

      # timestamps()
    end

    create index(:musictitles, [:music_id])
  end
end
