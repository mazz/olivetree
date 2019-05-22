defmodule DB.Repo.Migrations.PostDbImportTweaks do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      add :description, :text
      add :channelTitle, :string
      add :publishedAt, :utc_datetime
      add :tags, {:array, :string}
    end

    alter table(:mediaitems) do
      add :media_category, DB.Type.MediaCategory.type()
      add :presented_at, :utc_datetime, null: true
      # null published_at means never published
      add :published_at, :utc_datetime, null: true
      add :org_id, references(:orgs, on_delete: :delete_all)
    end

    alter table(:orgs) do
      add :shortname, :string
    end

    # create(unique_index(:videos, [:tags]))

    flush()
  end
end
