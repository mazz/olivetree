defmodule OlivetreeApi do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use OlivetreeApi, :controller
      use OlivetreeApi, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  alias Olivetree.Authenticator.GuardianImpl


  def controller do
    quote do
      use Phoenix.Controller, namespace: OlivetreeApi
      import Plug.Conn
      import OlivetreeApi.Gettext
      alias OlivetreeApi.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/olivetree_api/templates",
        namespace: OlivetreeApi

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import OlivetreeApi.ErrorHelpers
      import OlivetreeApi.Gettext
      alias OlivetreeApi.Router.Helpers, as: Routes

      def render_shared(template, assigns \\ []) do
        render(OlivetreeApi.SharedView, template, assigns)
      end

      def user_logged_in?(conn) do
        # !is_nil(Map.get(conn.assigns, :current_user))
        !is_nil(GuardianImpl.Plug.current_resource(conn))
      end

      import Phoenix.LiveView, only: [live_render: 2, live_render: 3]
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import OlivetreeApi.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
