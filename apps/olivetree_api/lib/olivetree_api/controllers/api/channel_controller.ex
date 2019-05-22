defmodule OlivetreeApi.ChannelController do
  use OlivetreeApi, :controller

  alias OlivetreeApi.ErrorView
  alias OlivetreeApi.ChannelV13View
  alias OlivetreeApi.V13

  require Logger
  require Ecto.Query

  action_fallback OlivetreeApi.FallbackController

  def indexv13(conn, %{"org-uuid" => orguuid, "offset" => offset, "limit" => limit}) do
    Logger.debug("orguuid #{inspect %{attributes: orguuid}}")
    V13.channels_by_org_uuid(orguuid, offset, limit)
    |> case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      channel_v13 ->
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            conn
            |> put_view(ChannelV13View)
            |> render("indexv13.json", %{channel_v13: channel_v13, api_version: api_version})
        end
    end
  end


end
