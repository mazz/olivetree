defmodule OlivetreeApi.ClientDeviceV12View do
  use OlivetreeApi, :view
  alias OlivetreeApi.ClientDeviceV12View
  require Logger

  def render("indexv12.json", %{client_device_v12: client_device_v12}) do
    Logger.debug("render client_device_v12 #{inspect %{attributes: client_device_v12}}")
    %{result: [],
    status: "success",
    version: "1.2"}
  end

  def render("show.json", %{client_device_v12: client_device_v12}) do
    %{data: render_one(client_device_v12, ClientDeviceV12View, "client_device_v12.json")}
  end

  def render("client_device_v12.json", %{client_device_v12: client_device_v12}) do
    %{client_device_v12: client_device_v12}
  end
end
