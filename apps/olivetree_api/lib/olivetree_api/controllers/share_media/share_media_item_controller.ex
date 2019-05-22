defmodule OlivetreeApi.ShareMediaItemController do
  use OlivetreeApi, :controller
  alias OlivetreeApi.V13

  require Logger

  # def index(conn, _params) do
  #   conn
  #   # |> assign(:users, Accounts.list_users())
  #   # |> assign(:current_user, Guardian.Plug.current_resource(conn))
  #   |> render("index.html")
  #   # render conn, "index.html"

  #   # |> send_resp(200, """
  #   #   index
  #   #   """)
  # end

  def show(conn, %{"hash_id" => hash_id}) do
    V13.media_item_by_hash_id(hash_id)
    |>
    case do
      nil ->
        put_status(conn, 404)
        |> put_view(ErrorView)
        |> render("404.json", %{message: "error showing media item."})
      media_item ->
        render(conn, "show.html", media_item: media_item)

        # conn
        # |> send_resp(200, """
        #   mediaitem: #{inspect %{attributes: media_item_v13}}
        #   """)


        # Enum.at(conn.path_info, 0)
        # |> case do
        #   api_version ->
        #     api_version = String.trim_leading(api_version, "v")
        #     conn
        #     |> put_view(MediaItemV13View)
        #     |> render("indexv13.json", %{media_item_v13: media_item_v13, api_version: api_version})
        # end
      end

    # conn
    # |> send_resp(200, """
    #   hash_id: #{hash_id}
    #   """)

  end
end
