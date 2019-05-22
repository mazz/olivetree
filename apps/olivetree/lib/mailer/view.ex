defmodule Olivetree.Mailer.View do
  use Phoenix.View, root: "lib/mailer/templates", namespace: Olivetree.Mailer
  use Phoenix.HTML

  import Olivetree.Gettext
  import Olivetree.Utils.FrontendRouter

  def user_appelation(user) do
    DB.Schema.User.user_appelation(user)
  end
end
