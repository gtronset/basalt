defmodule Honeycomb.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :honeycomb,
      version: @version,
      elixir: "~> 1.9",
      description: description(),
      name: "Honeycomb",
      start_permanent: Mix.env() == :prod,
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
      {:ex_doc, "~> 0.21.2"}
    ]
  end

  defp description() do
    """
    Honeycomb builds hexagonal grids in pure Elixir. Supports common computational and mapping for hexagons and hexagonal grids. 🐝
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "CHANGELOG.md", "src", ".formatter.exs"],
      maintainers: ["Gavin Tronset"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/gtronset/honeycomb"}
    ]
  end

  defp docs() do
    [
      main: "readme",
      name: "Honeycomb",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/honeycomb",
      source_url: "https://github.com/gtronset/honeycomb",
      extras: [
        "README.md"
      ]
    ]
  end
end
