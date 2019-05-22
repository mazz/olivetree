defmodule OlivetreeApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :olivetree_api,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {OlivetreeApi.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # {:arc, github: "Betree/arc", override: true},
      # {:arc, "~> 0.11.0"},
      # {:arc_ecto, "~> 0.11.1"},
      # {:httpoison, "~> 1.5.0"},
      # {:google_api_you_tube, "~> 0.2.0"},
      {:kaur, "~> 1.1"},
      {:oauth2, "~> 1.0"},
      {:phoenix, "~> 1.4"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 2.13"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.16.1"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:guardian, "~> 1.2"},
      {:comeonin, "~> 5.1"},
      {:bcrypt_elixir, "~> 2.0"},
      {:argon2_elixir, "~> 2.0"},
      {:corsica, "~> 1.1"},
      {:phoenix_live_view, github: "phoenixframework/phoenix_live_view"},

      # ---- Internal ----
      {:olivetree, in_umbrella: true},
      {:db, in_umbrella: true}

      # Auth
      # {:sans_password, "~> 1.0.0"},
      # {:recaptcha, "~> 2.3"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, we extend the test task to create and migrate the database.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [test: ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
