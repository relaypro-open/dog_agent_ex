defmodule DogAgentEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :dog_agent_ex,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: extra_applications(Mix.env()),
      mod: {:dog_agent_ex, []}
    ]
  end

  defp extra_applications(:dev), do: extra_applications(:all) ++ [:remix]
  defp extra_applications(_all), do: [:logger]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
    {:base16, git: "https://github.com/goj/base16.git", tag: "1.0.0"},
    {:bbmustache, "1.11.0"},
    {:erldocker, git: "https://github.com/Phonebooth/erldocker.git", branch: "feature/remove_lager"},
    {:flatlog, git: "https://github.com/ferd/flatlog.git", tag: "v0.1.2"},
    {:hackney, git: "https://github.com/benoitc/hackney.git", tag: "1.18.1", override: true},
    {:jsn, "2.1.4"},
    {:jsx, git: "https://github.com/talentdeficit/jsx.git", tag: "v2.8.3", override: true},
    {:logger_file_backend, "~> 0.0.11"},
    {:parse_trans, "3.4.1", override: true},
    {:remix, "~> 0.0.1", only: :dev},
    {:turtle, git: "https://github.com/relaypro-open/turtle.git", branch: "feature/remove_lager"},
    {:uuid, ">=0.0.0", hex: "uuid_erl"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
