defmodule OlivetreeApi.Admin.PushMessageController do
  use OlivetreeApi, :controller

  alias Olivetree.PushNotifications
  alias DB.Schema.PushMessage

  action_fallback OlivetreeApi.FallbackController

  def index(conn, _params) do
    pushmessage = PushNotifications.list_pushmessage()
    render(conn, "index.json", pushmessage: pushmessage)
  end

  def create(conn, %{"push_message" => push_message_params}) do
    with {:ok, %PushMessage{} = push_message} <- PushNotifications.create_push_message(push_message_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.push_message_path(conn, :show, push_message))
      |> render("show.json", push_message: push_message)
    end
  end

  def show(conn, %{"id" => id}) do
    push_message = PushNotifications.get_push_message!(id)
    render(conn, "show.json", push_message: push_message)
  end

  def update(conn, %{"id" => id, "push_message" => push_message_params}) do
    push_message = PushNotifications.get_push_message!(id)

    with {:ok, %PushMessage{} = push_message} <- PushNotifications.update_push_message(push_message, push_message_params) do
      render(conn, "show.json", push_message: push_message)
    end
  end

  def delete(conn, %{"id" => id}) do
    push_message = PushNotifications.get_push_message!(id)

    with {:ok, %PushMessage{}} <- PushNotifications.delete_push_message(push_message) do
      send_resp(conn, :no_content, "")
    end
  end
end
