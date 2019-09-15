defmodule Basalt.MixProject do
  use Mix.Project

  @version "0.1.0"
  @github_url "https://github.com/gtronset/basalt"

  def project do
    [
      app: :basalt,
      version: @version,
      elixir: "~> 1.9",
      description: description(),
      name: "Basalt",
      start_permanent: Mix.env() == :prod,
      source_url: @github_url,
      homepage_url: @github_url,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: [:test]},
      {:ex_doc, "~> 0.21.2", only: [:dev], runtime: false},
      {:inch_ex, "~> 2.0", only: [:docs]},
      {:junit_formatter, "~> 3.0", only: [:test]}
    ]
  end

  defp description() do
    """
    Basalt builds hexagonal grids in pure Elixir. Supports common
    computational and mapping for hexagons and hexagonal grids.
    """
  end

  defp package do
    [
      files: ~w(lib priv .formatter.exs mix.exs README* readme* LICENSE*
                license* CHANGELOG* changelog* src),
      maintainers: ["Gavin Tronset"],
      licenses: ["MIT"],
      links: %{"GitHub" => @github_url}
    ]
  end

  defp docs() do
    [
      main: "readme",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/basalt",
      source_url: @github_url,
      extras: [
        "README.md",
        "CHANGELOG.md"
      ]
    ]
  end
end
