defmodule Olivetree.PushNotifications do
  @moduledoc """
  The PushNotifications context.
  """

  import Ecto.Query, warn: false
  alias DB.Repo

  alias DB.Schema.PushMessage

  @doc """
  Returns the list of pushmessage.

  ## Examples

      iex> list_pushmessage()
      [%PushMessage{}, ...]

  """
  def list_pushmessage do
    Repo.all(PushMessage)
  end

  @doc """
  Gets a single push_message.

  Raises `Ecto.NoResultsError` if the Push message does not exist.

  ## Examples

      iex> get_push_message!(123)
      %PushMessage{}

      iex> get_push_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_push_message!(id), do: Repo.get!(PushMessage, id)

  @doc """
  Creates a push_message.

  ## Examples

      iex> create_push_message(%{field: value})
      {:ok, %PushMessage{}}

      iex> create_push_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_push_message(attrs \\ %{}) do
    %PushMessage{}
    |> PushMessage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a push_message.

  ## Examples

      iex> update_push_message(push_message, %{field: new_value})
      {:ok, %PushMessage{}}

      iex> update_push_message(push_message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_push_message(%PushMessage{} = push_message, attrs) do
    push_message
    |> PushMessage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PushMessage.

  ## Examples

      iex> delete_push_message(push_message)
      {:ok, %PushMessage{}}

      iex> delete_push_message(push_message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_push_message(%PushMessage{} = push_message) do
    Repo.delete(push_message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking push_message changes.

  ## Examples

      iex> change_push_message(push_message)
      %Ecto.Changeset{source: %PushMessage{}}

  """
  def change_push_message(%PushMessage{} = push_message) do
    PushMessage.changeset(push_message, %{})
  end
end
