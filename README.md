Basalt [![CircleCI](https://img.shields.io/circleci/build/github/gtronset/basalt)](https://circleci.com/gh/gtronset/basalt/tree/master) [![codecov](https://img.shields.io/codecov/c/github/gtronset/basalt)](https://codecov.io/gh/gtronset/basalt)
============

Basalt builds hexagonal grids in pure Elixir. Supports common computational and mapping for hexagons and hexagonal grids.

## Installation

The package can be installed by adding `basalt` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:basalt, "~> 0.1.0"}
  ]
end
```

## Basic Usage

``` elixir
  iex> Hex.create(1, 0, -1)
  {:ok, %Hex{q: 1, r: 0, s: -1}}
```

Full documentation can be found at [https://hexdocs.pm/basalt]
(https://hexdocs.pm/basalt).

## License

Basalt is released under the MIT License - see the [LICENSE](LICENSE)
file.