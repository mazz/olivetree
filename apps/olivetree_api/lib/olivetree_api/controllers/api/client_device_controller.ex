defmodule OlivetreeApi.ClientDeviceController do
  use OlivetreeApi, :controller

  alias OlivetreeApi.ClientDeviceV13View
  alias OlivetreeApi.ClientDeviceV12View
  alias OlivetreeApi.V12
  alias OlivetreeApi.V13

  require Logger
  action_fallback OlivetreeApi.FallbackController

  def indexv12(conn, %{"fcmToken" => fcm_token, "apnsToken" => apns_token, "preferredLanguage" => preferred_language, "userAgent" => user_agent}) do
    Logger.debug("fcm_token #{inspect %{attributes: fcm_token}}")
    V12.add_client_device(fcm_token, apns_token, preferred_language, user_agent)
    |> case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "something happened."})
      client_device_v12 ->
        Logger.debug("client_device_v12 #{inspect %{attributes: client_device_v12}}")
        conn
        |> put_view(ClientDeviceV12View)
        |> render("indexv12.json", %{client_device_v12: client_device_v12})
    end
  end

  def indexv13(conn, %{"fcmToken" => fcm_token, "apnsToken" => apns_token, "preferredLanguage" => preferred_language, "userAgent" => user_agent, "userVersion" => user_version}) do
    V13.add_client_device(fcm_token, apns_token, preferred_language, user_agent, user_version)
    |> case do
      nil ->
        put_status(conn, 403)
        |> put_view(ErrorView)
        |> render("403.json", %{message: "something happened."})
      client_device_v13 ->
        # Logger.debug("client_devices #{inspect %{attributes: client_devices}}")
        Logger.debug("client_device_v13 #{inspect %{attributes: client_device_v13}}")
        Enum.at(conn.path_info, 0)
        |> case do
          api_version ->
            Logger.debug("api_version #{inspect %{attributes: api_version}}")
            api_version = String.trim_leading(api_version, "v")
            conn
            |> put_view(ClientDeviceV13View)
            |> render("indexv13.json", %{client_device_v13: client_device_v13, api_version: api_version})
        end
    end
  end

end
