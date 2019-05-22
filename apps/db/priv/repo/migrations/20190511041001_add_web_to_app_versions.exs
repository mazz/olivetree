defmodule DB.Repo.Migrations.AddWebToAppVersions do
  use Ecto.Migration

  def change do
    alter table(:appversions) do
      add :web_supported, :boolean, default: false
    end

    flush()
  end
end
