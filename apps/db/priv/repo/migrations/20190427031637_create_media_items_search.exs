defmodule DB.Repo.Migrations.CreateMediaItemsSearch do
  use Ecto.Migration

  def change do
    execute(
      """
      CREATE EXTENSION IF NOT EXISTS unaccent
      """
    )

    execute(
      """
      CREATE EXTENSION IF NOT EXISTS pg_trgm
      """
    )

    execute(
      """
      CREATE MATERIALIZED VIEW media_items_search AS
      SELECT  mediaitems.id AS id,
              mediaitems.localizedname AS localizedname,
              (
                setweight(to_tsvector('english', COALESCE(localizedname,'')), 'A') ||
                setweight(to_tsvector('english', COALESCE(presenter_name,'')), 'B') ||
                setweight(to_tsvector('english', COALESCE(source_material,'')), 'C')
              )
              AS document
       FROM mediaitems;
      """
    )

    # to support full-text searches
    create index("media_items_search", ["document"], using: :gin)

    # to support substring localizedname matches with ILIKE
    execute("CREATE INDEX media_items_search_localizedname_trgm_index ON media_items_search USING gin (localizedname gin_trgm_ops)")

    # to support updating CONCURRENTLY
    create unique_index("media_items_search", [:id])

    flush()
  end
end
