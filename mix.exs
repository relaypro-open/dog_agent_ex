defmodule DogAgentEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :dog,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :dev,
      deps: deps(),
      releases: [
        dog: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: extra_applications(Mix.env()),
      mod: {:dog, []}
    ]
  end

  #defp extra_applications(:dev), do: extra_applications(:all) ++ [:remix]
  defp extra_applications(_all), do: [:logger, :turtle]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:base16, git: "https://github.com/goj/base16.git", tag: "1.0.0"},
      {:bbmustache, "1.11.0"},
      {:erldocker, git: "https://github.com/Phonebooth/erldocker.git", branch: "feature/erlang_24"},
      {:erlexec, "~> 1.0"},
      {:erlsh, git: "https://github.com/proger/erlsh.git", tag: "2", override: true},
      {:exometer_core, git: "https://github.com/fkrause98/exometer_core.git", override: true},
      {:flatlog, git: "https://github.com/ferd/flatlog.git", tag: "v0.1.2"},
      {:hackney, git: "https://github.com/benoitc/hackney.git", tag: "1.18.1", override: true},
      {:jsn, "2.1.4"},
      {:jsx, git: "https://github.com/talentdeficit/jsx.git", tag: "v2.8.3", override: true},
      {:logger_file_backend, "~> 0.0.11"},
      {:observer_cli, "~> 1.7"},
      {:parse_trans, "3.4.1", override: true},
      {:turtle, git: "https://github.com/relaypro-open/turtle.git", branch: "feature/erlang_24"},
      {:uuid, "~> 2.0", hex: :uuid_erl},
      {:dotenvy, "~> 0.7.0"}
    ]
  end

end

