defmodule Olivetree.MixProject do
  use Mix.Project

  def project do
    [
      app: :olivetree,
      version: "0.1.0",
      build_path: "../../_build",
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      # aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Olivetree.Application, []},
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
      {:httpoison, "~> 1.5.0"},
      {:mochiweb, "~> 2.18"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:bamboo, "~> 1.2"},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"},
      {:yamerl, "~> 0.7.0"},
      {:yaml_elixir, "~> 2.2"},
      {:not_qwerty123, "~> 2.3"},
      {:arc, "~> 0.11.0"},
      {:arc_ecto, "~> 0.11.0"},
      {:ecto_enum, "~> 1.2"},
      {:burnex, "~> 1.1"},
      {:guardian, "~> 1.2"},
      {:guardian_db, "~> 2.0"},
      {:floki, "~> 0.21.0"},
      {:parse_trans, "~> 3.3"},
      {:scrivener_ecto, "~> 2.2"},
      {:google_api_you_tube, "~> 0.4.0"},
      {:hashids, "~> 2.0"},
      {:rollbax, "~> 0.10.0"},
      {:pigeon, "~> 1.3"},
      {:kadabra, "~> 0.4.4"},
      # {:guardian, "~> 1.1"},
      # {:comeonin, "~> 4.1"},
      # {:bcrypt_elixir, "~> 1.1"},
      # {:argon2_elixir, "~> 1.3"}

      # ---- Internal ----
      {:db, in_umbrella: true}


    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.

end
