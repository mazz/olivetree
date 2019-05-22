defmodule DB.Repo.Migrations.CreateAchievements do
  use Ecto.Migration

  def change do
    create table(:achievements) do
      add :slug, :string
      add :rarity, :integer

      timestamps(type: :utc_datetime)
    end

    create unique_index(:achievements, [:slug])
  end
end
