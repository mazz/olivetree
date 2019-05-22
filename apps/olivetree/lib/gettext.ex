defmodule Olivetree.Gettext do
  use Gettext, otp_app: :olivetree

  defmacro with_user_locale(user, do: expression) do
    quote do
      locale = Map.get(unquote(user), :locale) || "en"

      Gettext.with_locale(Olivetree.Gettext, locale, fn ->
        unquote(expression)
      end)
    end
  end

  defmacro gettext_mail(msgid, vars \\ []) do
    quote do
      Olivetree.Gettext.dgettext("mail", unquote(msgid), unquote(vars))
    end
  end

  defmacro gettext_mail_user(user, msgid, vars \\ []) do
    quote do
      locale = Map.get(unquote(user), :locale) || "en"

      Gettext.with_locale(Olivetree.Gettext, locale, fn ->
        Olivetree.Gettext.dgettext("mail", unquote(msgid), unquote(vars))
      end)
    end
  end
end
