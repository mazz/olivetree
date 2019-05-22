defmodule DB.Repo.Migrations.AddPushMessagesToOrg do
  use Ecto.Migration

  def change do
    alter table(:pushmessages) do
      add :media_url, :string, null: true
      add :sound, :string, null: true
      add :org_id, references(:orgs, on_delete: :delete_all)
    end

    flush()
  end
end
