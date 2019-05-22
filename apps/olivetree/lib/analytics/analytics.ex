defmodule DB.Schema do
  @moduledoc """
  The Analytics context.
  """

  import Ecto.Query, warn: false
  alias DB.Repo

  alias DB.Schema.ClientDevice

  @doc """
  Returns the list of clientdevice.

  ## Examples

      iex> list_clientdevice()
      [%ClientDevice{}, ...]

  """
  def list_clientdevice do
    Repo.all(ClientDevice)
  end

  @doc """
  Gets a single client_device.

  Raises `Ecto.NoResultsError` if the Client device does not exist.

  ## Examples

      iex> get_client_device!(123)
      %ClientDevice{}

      iex> get_client_device!(456)
      ** (Ecto.NoResultsError)

  """
  def get_client_device!(id), do: Repo.get!(ClientDevice, id)

  @doc """
  Creates a client_device.

  ## Examples

      iex> create_client_device(%{field: value})
      {:ok, %ClientDevice{}}

      iex> create_client_device(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_client_device(attrs \\ %{}) do
    %ClientDevice{}
    |> ClientDevice.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a client_device.

  ## Examples

      iex> update_client_device(client_device, %{field: new_value})
      {:ok, %ClientDevice{}}

      iex> update_client_device(client_device, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_client_device(%ClientDevice{} = client_device, attrs) do
    client_device
    |> ClientDevice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ClientDevice.

  ## Examples

      iex> delete_client_device(client_device)
      {:ok, %ClientDevice{}}

      iex> delete_client_device(client_device)
      {:error, %Ecto.Changeset{}}

  """
  def delete_client_device(%ClientDevice{} = client_device) do
    Repo.delete(client_device)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking client_device changes.

  ## Examples

      iex> change_client_device(client_device)
      %Ecto.Changeset{source: %ClientDevice{}}

  """
  def change_client_device(%ClientDevice{} = client_device) do
    ClientDevice.changeset(client_device, %{})
  end

  alias DB.Schema.AppVersion

  @doc """
  Returns the list of appversion.

  ## Examples

      iex> list_appversion()
      [%AppVersion{}, ...]

  """
  def list_appversion do
    Repo.all(AppVersion)
  end

  @doc """
  Gets a single app_version.

  Raises `Ecto.NoResultsError` if the App version does not exist.

  ## Examples

      iex> get_app_version!(123)
      %AppVersion{}

      iex> get_app_version!(456)
      ** (Ecto.NoResultsError)

  """
  def get_app_version!(id), do: Repo.get!(AppVersion, id)

  @doc """
  Creates a app_version.

  ## Examples

      iex> create_app_version(%{field: value})
      {:ok, %AppVersion{}}

      iex> create_app_version(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_app_version(attrs \\ %{}) do
    %AppVersion{}
    |> AppVersion.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a app_version.

  ## Examples

      iex> update_app_version(app_version, %{field: new_value})
      {:ok, %AppVersion{}}

      iex> update_app_version(app_version, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_app_version(%AppVersion{} = app_version, attrs) do
    app_version
    |> AppVersion.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a AppVersion.

  ## Examples

      iex> delete_app_version(app_version)
      {:ok, %AppVersion{}}

      iex> delete_app_version(app_version)
      {:error, %Ecto.Changeset{}}

  """
  def delete_app_version(%AppVersion{} = app_version) do
    Repo.delete(app_version)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking app_version changes.

  ## Examples

      iex> change_app_version(app_version)
      %Ecto.Changeset{source: %AppVersion{}}

  """
  def change_app_version(%AppVersion{} = app_version) do
    AppVersion.changeset(app_version, %{})
  end
end
