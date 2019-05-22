defmodule DB.Repo.Migrations.CreateAppversion do
  use Ecto.Migration

  def change do
    create table(:appversions) do

      add :uuid, :uuid
      add :version_number, :string
      add :ios_supported, :boolean, default: false, null: false
      add :android_supported, :boolean, default: false, null: false

      # timestamps()
    end

  end
end
