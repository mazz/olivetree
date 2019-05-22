defmodule DB.Repo.Migrations.CreateBook do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :absolute_id, :integer
      add :uuid, :uuid
      add :basename, :string

      # timestamps()
    end

  end
end
