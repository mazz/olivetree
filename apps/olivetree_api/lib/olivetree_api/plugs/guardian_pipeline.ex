defmodule OlivetreeApi.Plugs.GuardianPipeline do
  @moduledoc """
  Main pipeline for Guardian set-up on each request.
  """

  use Guardian.Plug.Pipeline, otp_app: :olivetree_api

  alias OlivetreeApi.Plugs.CurrentUser

  plug Guardian.Plug.Pipeline,
    module: OlivetreeApi.Guardian,
    error_handler: OlivetreeApi.LoginController

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.LoadResource, allow_blank: true

  plug CurrentUser
end
