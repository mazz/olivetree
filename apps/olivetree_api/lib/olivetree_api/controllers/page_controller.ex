defmodule OlivetreeApi.PageController do
  use OlivetreeApi, :controller
  alias OlivetreeApi.Guardian

  def index(conn, _params) do
    conn
    # |> assign(:users, Accounts.list_users())
    # |> assign(:current_user, Guardian.Plug.current_resource(conn))
    |> render("index.html")
    # render conn, "index.html"

    # |> send_resp(200, """
    #   index
    #   """)
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end

end
