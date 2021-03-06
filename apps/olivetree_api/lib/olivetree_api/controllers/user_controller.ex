defmodule OlivetreeApi.UserController do
  use OlivetreeApi, :controller

  alias DB.Schema.User
  alias DB.Type.Achievement

  alias Olivetree.Accounts
  alias Olivetree.Accounts.Invitations
  alias Olivetree.Accounts.UserPermissions
  alias Olivetree.Authenticator.GuardianImpl
  alias OlivetreeApi.UserView
  alias DB.Repo

  alias Kaur.Result

  require Logger

  action_fallback(OlivetreeApi.FallbackController)

  plug(
    Guardian.Plug.EnsureAuthenticated,
    [handler: OlivetreeApi.AuthController]
    when action in [
           :update,
           :delete,
           :available_flags,
           :show_me,
           :unlock_achievement,
           :complete_onboarding_step,
           :delete_onboarding
         ]
  )

  def create(conn, params = %{"user" => user_params}) do
    case Accounts.create_account(user_params, Map.get(params, "invitation_token")) do
      {:ok, user} ->
        {:ok, token, _claims} = GuardianImpl.encode_and_sign(user, [])

        conn
        |> put_status(:created)
        |> render("user_with_token.json", %{user: user, token: token})

      {:error, changeset = %Ecto.Changeset{}} ->
        conn
        |> put_status(:bad_request)
        |> render(OlivetreeApi.ChangesetView, "error.json", changeset: changeset)

      {:error, message} ->
        conn
        |> put_status(:bad_request)
        |> render(OlivetreeApi.ErrorView, "error.json", %{message: message})
    end
  end

  def show(conn, %{"username" => username}) do
    case Repo.get_by(User, username: username) do
      nil -> {:error, :not_found}
      user -> render(conn, "show_public.json", user: user)
    end
  end

  def show_me(conn, _params) do
    render(conn, UserView, :show, user: GuardianImpl.Plug.current_resource(conn))
  end

  def update(conn, params) do
    conn
    |> GuardianImpl.Plug.current_resource()
    |> Accounts.update(params)
    |> case do
      {:ok, user} ->
        render(conn, :show, user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OlivetreeApi.ChangesetView, :error, changeset: changeset)
    end
  end

  def available_flags(conn, _) do
    current_user = GuardianImpl.Plug.current_resource(conn)

    case UserPermissions.check(current_user, :flag, :comment) do
      {:ok, num_available} -> json(conn, %{flags_available: num_available})
      {:error, _reason} -> json(conn, %{flags_available: 0})
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    Logger.debug("confirm_email token: #{token}")
    try do
      Accounts.confirm_email!(token)
      send_resp(conn, :no_content, "")
    rescue
      _ -> json(put_status(conn, 404), %{error: "invalid_token"})
    end
  end

  def delete(conn, _params) do
    # TODO Soft delete, do the real delete after 1 week to avoid user mistakes
    conn
    |> GuardianImpl.Plug.current_resource()
    |> Accounts.delete_account()
    |> Result.and_then(fn _ ->
      send_resp(conn, :no_content, "")
    end)
  end

  @user_unlockable_achievements [Achievement.get(:help), Achievement.get(:bulletproof)]
  def unlock_achievement(conn, %{"achievement" => achievement}) do
    with {achievement_id, _} <- Integer.parse(achievement),
         true <- achievement_id in @user_unlockable_achievements,
         {:ok, user} <-
           Accounts.unlock_achievement(GuardianImpl.Plug.current_resource(conn), achievement_id) do
      render(conn, UserView, :show, user: user)
    else
      _ ->
        send_resp(
          conn,
          400,
          "Invalid achievement id. Must be one of: #{@user_unlockable_achievements}"
        )
    end
  end

  # ---- Onboarding step ----

  def complete_onboarding_step(conn, %{"step" => step}) do
    conn
    |> GuardianImpl.Plug.current_resource()
    |> Accounts.complete_onboarding_step(step)
    |> Result.either(
      fn reason ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OlivetreeApi.ChangesetView, "error.json", %{changeset: reason})
      end,
      fn user ->
        conn
        |> render(UserView, :show, user: user)
      end
    )
  end

  def complete_onboarding_steps(conn, %{"steps" => steps} = _params) do
    conn
    |> GuardianImpl.Plug.current_resource()
    |> Accounts.complete_onboarding_steps(steps)
    |> Result.either(
      fn reason ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OlivetreeApi.ChangesetView, "error.json", %{changeset: reason})
      end,
      fn user ->
        conn
        |> render(UserView, :show, user: user)
      end
    )
  end

  def delete_onboarding(conn, _params) do
    conn
    |> GuardianImpl.Plug.current_resource()
    |> Accounts.delete_onboarding()
    |> Result.either(
      fn _reason ->
        Result.error("unexpected")
      end,
      fn user ->
        conn
        |> render(UserView, :show, user: user)
      end
    )
  end

  # ---- Reset password ----

  def reset_password_request(conn, %{"email" => email}) do
    try do
      Accounts.reset_password!(email, Enum.join(Tuple.to_list(conn.remote_ip), "."))
    rescue
      _ in Ecto.NoResultsError -> "I won't tell the user ;)'"
    end

    send_resp(conn, :no_content, "")
  end

  def reset_password_verify(conn, %{"token" => token}) do
    user = Accounts.check_reset_password_token!(token)
    render(conn, UserView, :show, %{user: user})
  end

  def reset_password_confirm(conn, %{"token" => token, "password" => password}) do
    user = Accounts.confirm_password_reset!(token, password)
    render(conn, UserView, :show, %{user: user})
  end

  # ---- Invitations ----

  def request_invitation(conn, params = %{"email" => email}) do
    connected_user = GuardianImpl.Plug.current_resource(conn)

    case Invitations.request_invitation(email, connected_user, params["locale"]) do
      {:ok, _} ->
        send_resp(conn, :no_content, "")

      {:error, "invalid_email"} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "invalid_email"})

      {:error, _} ->
        send_resp(conn, :bad_request, "")
    end
  end

  # ---- Newsletter ----

  def newsletter_unsubscribe(conn, %{"token" => token}) do
    case Repo.get_by(User, newsletter_subscription_token: token) do
      nil ->
        json(put_status(conn, :bad_request), %{error: "invalid_token"})

      user ->
        Repo.update(Ecto.Changeset.change(user, newsletter: false))
        send_resp(conn, 204, "")
    end
  end
end
