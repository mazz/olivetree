defmodule Olivetree.Mailer do
  import Bamboo.Email

  use Bamboo.Mailer, otp_app: :olivetree

  def welcome_email(user, _opts) do
    new_email(
      to: user.email,
      from: "noreply@faithfword.app",
      subject: "Welcome to Olivetree.",
      html_body: "<strong>Olivetree -- welcome\n\n",
      text_body: "Thanks for joining!\n"
    )
  end
end
