defmodule DB.Repo.Migrations.AddHashIdToChannels do
  use Ecto.Migration
  import Ecto.Query
  alias DB.Schema.Channel

  def up do
    alter table(:channels) do
      # A size of 10 allows us to go up to 100_000_000_000_000 media items
      add(:hash_id, :string, size: 12)
    end

    # Create unique index on hash_id
    create(unique_index(:channels, [:hash_id]))

    # Flush pending migrations to ensure column is created
    flush()

  end

  def down do
    alter table(:channels) do
      remove(:hash_id)
    end
  end
end
