defmodule DB.Type.OrgHashId do
  @moduledoc """
  Convert a media item integer id to hash
  """

  defmodule InvalidOrgHashError do
    @moduledoc """
    Exception throwed when hash is not valid
    """
    defexception plug_status: 404, message: "Not found", conn: nil, router: nil
  end

  @coder Hashids.new(
           min_len: 4,
           alphabet: "23456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKMNOPQRSTUVWXYZ",
           salt: "F41thfu1W0rD0rg"
         )

  @doc """
  Encode a given id
  ## Examples
      iex> DB.Type.OrgHashId.encode(42)
      "4VyJ"
  """
  @spec encode(Integer.t()) :: String.t()
  def encode(id) do
    Hashids.encode(@coder, id)
  end

  @doc """
  Decode a given hash
  ## Examples
      iex> DB.Type.OrgHashId.decode("JbOz")
      {:ok, 1337}
      iex> DB.Type.OrgHashId.decode("€€€€€€€€€€€€€€€€€")
      {:error, :invalid_input_data}
  """
  @spec decode(String.t()) :: Integer.t()
  def decode(hash) do
    case do_decode(hash) do
      {:ok, [id]} -> {:ok, id}
      error -> error
    end
  end

  @doc """
  Decode a given hash. Raise if hash is invalid
  ## Examples
      iex> DB.Type.OrgHashId.decode!("JbOz")
      1337
      iex> catch_throw(DB.Type.OrgHashId.decode!("€€€"))
      DB.Type.OrgHashId.InvalidOrgHashError
  """
  @spec decode!(String.t()) :: Integer.t()
  def decode!(hash) do
    case do_decode(hash) do
      {:ok, [id]} -> id
      _error -> throw(InvalidOrgHashError)
    end
  end

  defp do_decode(hash),
    do: Hashids.decode(@coder, hash)
end
