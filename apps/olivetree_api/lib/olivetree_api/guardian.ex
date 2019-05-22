defmodule OlivetreeApi.Guardian do
  @moduledoc """
  Main Guardian module definition, including how to store and recover users from
  and to the session.
  """

  use Guardian, otp_app: :olivetree_api

  alias DB.Repo
  alias DB.Schema.User
  alias Kaur.Result

  require Logger

  def subject_for_token(%User{id: id}, _claims) do
    Logger.info("subject_for_token resource")
    Result.ok("User:#{id}")
  end

  def subject_for_token(_, _) do
    Logger.info("subject_for_token resource error")
    Result.error("token is based on a user")
  end

  def resource_from_claims(claims) do
    "User:" <> user_id = claims["sub"]
    User
    |> Repo.get(user_id)
    |> Result.from_value()
    |> Result.map_error(fn :no_value -> :user_not_found end)
  end

end
