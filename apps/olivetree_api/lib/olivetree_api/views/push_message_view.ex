defmodule OlivetreeApi.PushMessageView do
  use OlivetreeApi, :view
  alias OlivetreeApi.PushMessageView

  def render("index.json", %{pushmessage: pushmessage}) do
    %{data: render_many(pushmessage, PushMessageView, "push_message.json")}
  end

  def render("show.json", %{push_message: push_message}) do
    %{data: render_one(push_message, PushMessageView, "push_message.json")}
  end

  def render("push_message.json", %{push_message: push_message}) do
    %{id: push_message.id,
      uuid: push_message.uuid,
      created_at: push_message.created_at,
      updated_at: push_message.updated_at,
      title: push_message.title,
      message: push_message.message,
      sent: push_message.sent}
  end
end
