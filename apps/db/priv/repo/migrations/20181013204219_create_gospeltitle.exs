defmodule DB.Repo.Migrations.CreateGospeltitle do
  use Ecto.Migration

  def change do
    create table(:gospeltitles) do
      add :uuid, :uuid
      add :localizedname, :string
      add :language_id, :string
      add :gospel_id, references(:gospel, on_delete: :nothing)

      # timestamps()
    end

    create index(:gospeltitles, [:gospel_id])
  end
end
