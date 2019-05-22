defmodule DB.Repo.Migrations.CreateChapter do
  use Ecto.Migration

  def change do
    create table(:chapters) do
      add :absolute_id, :integer
      add :uuid, :uuid
      add :basename, :string
      add :book_id, references(:books, on_delete: :nothing)

      # timestamps()
    end

    create index(:chapters, [:book_id])
  end
end
