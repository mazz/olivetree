# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DB.Repo.insert!(%Olivetree.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias DB.Repo
alias DB.Schema.MediaItem
alias DB.Schema.Playlist
alias DB.Schema.Channel
alias DB.Schema.Org
alias DB.Schema.Video

import Ecto.Query
require Logger

# book =
#   DB.Schema.Book.changeset(%DB.Schema.Book{}, %{
#     absolute_id: 100,
#     basename: "Genesis",
#     uuid: Ecto.UUID.generate,
#     chapter: %DB.Schema.Chapter{}
#   })

#   Repo.insert!(book)

Logger.debug("Application.get_env #{Application.get_env(:db, :env)}")
# Create Admin in dev or if we're running image locally
# if Application.get_env(:db, :env) == :dev do
# Logger.warn("API is running in dev mode. Inserting default user admin@olivetree.app")

# No need to warn if already exists

# Update all existing mediaitems with their hashIds
DB.Repo.all(from mi in MediaItem)
|> Enum.map(&MediaItem.changeset_generate_hash_id/1)
|> Enum.map(&DB.Repo.update/1)

# Update all existing playlist with their hashIds
DB.Repo.all(from p in Playlist)
|> Enum.map(&Playlist.changeset_generate_hash_id/1)
|> Enum.map(&DB.Repo.update/1)

# Update all existing channel with their hashIds
DB.Repo.all(from c in Channel)
|> Enum.map(&Channel.changeset_generate_hash_id/1)
|> Enum.map(&DB.Repo.update/1)

DB.Repo.all(from o in Org)
|> Enum.map(&Org.changeset_generate_hash_id/1)
|> Enum.map(&DB.Repo.update/1)

DB.Repo.all(from v in Video)
|> Enum.map(&Video.changeset_generate_hash_id/1)
|> Enum.map(&DB.Repo.update/1)
