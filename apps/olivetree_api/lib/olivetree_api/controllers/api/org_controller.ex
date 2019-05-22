defmodule OlivetreeApi.OrgController do
  use OlivetreeApi, :controller

  alias OlivetreeApi.ErrorView
  alias OlivetreeApi.OrgV13View
  alias OlivetreeApi.ChannelV13View
  alias OlivetreeApi.V13

  require Logger
  require Ecto.Query

  action_fallback OlivetreeApi.FallbackController

  def defaultv13(conn, %{"offset" => offset, "limit" => limit}) do
    # Logger.debug("orgid #{inspect %{attributes: orgid}}")
    V13.orgs_default_org(offset, limit)
    |> case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "language not found in supported list."})
      org_v13 ->
        # Logger.debug("books #{inspect %{attributes: books}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            api_version = String.trim_leading(api_version, "v")
            conn
            |> put_view(OrgV13View)
            |> render("defaultv13.json", %{org_v13: org_v13, api_version: api_version})
        end
    end
  end

  def channelsv13(conn, %{"uuid" => orguuid, "offset" => offset, "limit" => limit}) do
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
            |> render("channelsv13.json", %{channel_v13: channel_v13, api_version: api_version})
        end
    end
  end
end
