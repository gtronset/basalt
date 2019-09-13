defmodule Honeycomb.Hex do
  alias Honeycomb.Hex, as: Hex

  @moduledoc """
  Honeycomb hexagon tiles are represented by hexagon tiles using
  "Cube" coordinates by default. Hexagons can be conceived as having
  three primary axes, as in a cube sliced on a diagonal plane.

  Cube notation utilizes "q", "r", "s" for coordinates and have a
  constraint `q + r + s = 0` which is always respected.

  ## API
  Most of the functions in this module return `:ok` or
  `{:ok, result}` in case of success, `{:error, reason}`
  otherwise. Those functions also have a variant
  that ends with `!` which returns the result (instead of the
  `{:ok, result}` tuple) in case of success or raises an
  exception in case it fails. For example:

      Hex.create(1, 0, -1)
      #=> {:ok, %Hex{q: 1, r: 0, s: -1}}

      Hex.create(1, 1, 1)
      #=> {:error, "invalid coordinates, constraint q + r + s = 0"}

      File.read!(1, 0, -1)
      #=> %Hex{q: 1, r: 0, s: -1}

      File.read!(1, 1, 1)
      #=> raises ArgumentError

  In general, a developer should use the former in case they want
  to react if the Hex does not exist. The latter should be used
  when the developer expects their software to fail in case the
  file cannot be read (i.e. it is literally an exception).
  """

  defstruct q: 0, r: 0, s: 0
  @typedoc "Hex Tile"
  @opaque t :: %__MODULE__{q: integer, r: integer, s: integer}

  defguardp is_hex_cube(q, r, s) when q + r + s == 0

  @doc """
  Creates a new hex.

  Returns `{:ok, hex}`, where `hex` is a hexagon objectthat contains
  coordinates "q", "r", "s", or `{:error, reason}` if an error occurs.
  """
  @spec create(number, number, number) :: {:ok, t} | {:error, String.t()}
  def create(q, r, s) when not is_hex_cube(q, r, s) do
    {:error, "invalid coordinates, constraint q + r + s = 0"}
  end

  def create(q, r, s), do: {:ok, %Hex{q: q, r: r, s: s}}

  @doc """
  Creates a new hex.

  Returns `hex` is a hexagon object that contains coordinates
  "q", "r", "s", or raises an `ArgumentError` exception if the
  given arguments don't satisfy the constraint `q + r + s = 0`.
  """
  @spec create!(number, number, number) :: t
  def create!(q, r, s) do
    case create(q, r, s) do
      {:ok, hex} ->
        hex

      {:error, message} ->
        raise ArgumentError, message: message
    end
  end
end
