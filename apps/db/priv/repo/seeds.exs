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
alias DB.Schema.User
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
Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "Amos"}, %{
  email: "amos@olivetree.app",
  password: "password"
}))
Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "Peter"}, %{
  email: "peter@olivetree.app",
  password: "password"
}))
Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "Joseph"}, %{
  email: "joseph@olivetree.app",
  password: "password"
}))
Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "Adam"}, %{
  email: "adam@olivetree.app",
  password: "password"
}))
Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "Jonathan"}, %{
  email: "jonathan@olivetree.app",
  password: "password"
}))
Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "Collin"}, %{
  email: "collin@olivetree.app",
  password: "password"
}))
Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "Michael"}, %{
  email: "michael@olivetree.app",
  password: "password"
}))

