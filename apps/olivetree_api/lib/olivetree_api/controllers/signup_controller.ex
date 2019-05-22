defmodule OlivetreeApi.SignupController do
  import Olivetree.Mailer

  use OlivetreeApi, :controller

  alias Olivetree.Accounts
  alias Olivetree.Accounts.Admin
  alias OlivetreeApi.Guardian

  # require Ecto.Query
  # require Logger

  plug :scrub_params, "signup" when action in [:create]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"signup" => auth_params}) do
    with {:ok, email} <- Map.fetch(auth_params, "email"),
         {:ok, password} <- Map.fetch(auth_params, "password"),
         {:ok, user} <- Accounts.authenticate(email, password) do
      conn
      # |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, gettext("%{user_email} already exists.", user_email: user.email))
        |> redirect(to: Routes.page_path(conn, :index))
    else
      _ ->
        conn
        |> put_flash(:info, gettext("Please check your email for your confirmation link."))
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  # def destroy(conn, _params) do
  #   conn
  #   |> Guardian.Plug.sign_out()
  #   |> put_flash(:info, gettext("Successfully logged out! See you!"))
  #   |> redirect(to: Routes.login_path(conn, :new))
  # end

  # def login_error(conn, {_type, _reason}, _opts) do
  #   conn
  #   |> put_flash(:error, gettext("Authentication required"))
  #   |> redirect(to: Routes.login_path(conn, :new))
  # end

  # def callback(conn, %{"magic_token" => magic_token}) do
  #   # require Logger
  #   # {:ok, access_token, _claims} = OlivetreeApi.Guardian.exchange_magic(magic_token)
  #   # Logger.debug """
  #   # access_token: #{inspect(access_token)}
  #   # _claims: #{inspect(_claims)}
  #   # """
  #   case Guardian.decode_magic(magic_token) do
  #     {:ok, user, _claims} ->
  #       conn
  #       |> Guardian.Plug.sign_in(user)
  #       |> redirect(to: Routes.page_path(conn, :index))

  #     _ ->
  #       conn
  #       |> put_flash(:error, "Invalid magic link.")
  #       |> redirect(to: Routes.login_path(conn, :new))
  #   end
  # end
end
