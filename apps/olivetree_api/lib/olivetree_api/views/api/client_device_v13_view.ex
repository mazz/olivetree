defmodule OlivetreeApi.ClientDeviceV13View do
  use OlivetreeApi, :view
  alias OlivetreeApi.ClientDeviceV13View
  require Logger

  def render("indexv13.json", %{client_device_v13: client_device_v13, api_version: api_version}) do
    Logger.debug("render client_device_v13 #{inspect %{attributes: client_device_v13}}")
    %{result: [],
    status: "success",
    version: api_version}
  end

  def render("show.json", %{client_device_v13: client_device_v13}) do
    %{data: render_one(client_device_v13, ClientDeviceV13View, "client_device_v13.json")}
  end

  def render("client_device_v13.json", %{client_device_v13: client_device_v13}) do
    %{client_device_v13: client_device_v13}
  end
end
