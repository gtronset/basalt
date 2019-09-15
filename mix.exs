defmodule Basalt.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :basalt,
      version: @version,
      elixir: "~> 1.9",
      description: description(),
      name: "Basalt",
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/gtronset/basalt",
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
      {:ex_doc, "~> 0.21.2", only: :dev, runtime: false}
    ]
  end

  defp description() do
    """
    Basalt builds hexagonal grids in pure Elixir. Supports common computational and mapping for hexagons and hexagonal grids.
    """
  end

  defp package do
    [
      files: ~w(lib priv .formatter.exs mix.exs README* readme* LICENSE*
                license* CHANGELOG* changelog* src),
      maintainers: ["Gavin Tronset"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/gtronset/basalt"}
    ]
  end

  defp docs() do
    [
      main: "readme",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/basalt",
      source_url: "https://github.com/gtronset/basalt",
      extras: [
        "README.md", "CHANGELOG.md"
      ]
    ]
  end
end
