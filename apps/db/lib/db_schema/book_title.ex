defmodule DB.Schema.BookTitle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "booktitles" do
    field :language_id, :string
    field :localizedname, :string
    field :uuid, Ecto.UUID
    field :book_id, :id

    # timestamps()
  end

  @doc false
  def changeset(book_title, attrs) do
    book_title
    |> cast(attrs, [:uuid, :localizedname, :language_id])
    |> validate_required([:uuid, :localizedname, :language_id])
  end
end
