defmodule Basalt.Hex do
  alias Basalt.Hex, as: Hex

  @moduledoc """
  Basalt hexagon tiles ("hexes") are represented by hexagon tiles using
  "Cube" coordinates by default. Hexagons can be conceived as having
  three primary axes, as in a cube sliced on a diagonal plane. Hexes are
  in oriented "pointy"-side up, ⬢. The other orientation is "flat", ⬣.

  Cube notation utilizes "q", "r", "s" for coordinates and have a
  constraint `q + r + s = 0` which is always respected.

  ## API
  Most of the functions in this module return `:ok` or
  `{:ok, result}` in case of success, `{:error, reason}`
  otherwise. Those functions also have a variant
  that ends with `!` which returns the result (instead of the
  `{:ok, result}` tuple) in case of success or raises an
  exception in case it fails. For example:

      iex> Hex.create(1, 0, -1)
      {:ok, %Hex{q: 1, r: 0, s: -1}}

      iex> Hex.create(1, 1, 1)
      {:error, "invalid coordinates, constraint q + r + s = 0"}

      iex> Hex.create!(1, 0, -1)
      %Hex{q: 1, r: 0, s: -1}

      iex> Hex.create!(1, 1, 1)
      ** (ArgumentError) invalid coordinates, constraint q + r + s = 0

  In general, a developer should use the former in case they want
  to react if the Hex does not exist. The latter should be used
  when the developer expects their software to fail in case the
  file cannot be read (i.e. it is literally an exception).
  """

  defstruct q: 0, r: 0, s: 0
  @typedoc "Hex Tile"
  @opaque t :: %__MODULE__{q: integer, r: integer, s: integer}

  defguardp is_valid_cube_coords(q, r, s) when q + r + s == 0

  @doc """
  Creates a new Hex.

  Returns `{:ok, Hex}`, where `Hex` is a hexagon object that contains
  coordinates "q", "r", "s". Returns `{:error, reason}` if an error occurs.
  """
  @spec create(number, number, number) :: {:ok, t} | {:error, String.t()}
  def create(q, r, s) when not is_valid_cube_coords(q, r, s) do
    {:error, "invalid coordinates, constraint q + r + s = 0"}
  end

  def create(q, r, s), do: {:ok, %Hex{q: q, r: r, s: s}}

  @doc """
  Creates a new Hex.

  Returns `Hex`, a hexagon object that contains coordinates
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

  @doc """
  Adds two Hexes.

  Returns a new Hex.
  """
  @spec add(t, t) :: t
  def add(%Hex{} = a, %Hex{} = b) do
    Hex.create!(a.q + b.q, a.r + b.r, a.s + b.s)
  end

  @doc """
  Subtracts two Hexes.

  Returns a new Hex.
  """
  @spec subtract(t, t) :: t
  def subtract(%Hex{} = a, %Hex{} = b) do
    Hex.create!(a.q - b.q, a.r - b.r, a.s - b.s)
  end

  @doc """
  Scales a hex with given multiplier `k`.

  Returns a new scaled Hex.
  """
  @spec scale(t, non_neg_integer) :: t
  def scale(%Hex{} = hex, k) when is_integer(k) do
    Hex.create!(hex.q * k, hex.r * k, hex.s * k)
  end

  @doc """
  The distance ("length") between a given Hex and the hexagonal grid's
  origin.

  Returns an integer representing the tile "steps" from origin.
  """
  @spec distance(t) :: integer
  def distance(%Hex{} = hex) do
    round((abs(hex.q) + abs(hex.r) + abs(hex.s)) / 2)
  end

  @doc """
  The distance between two hexes is the "length" between the two
  hexes.

  Returns an integer representing the tile "steps" from the two hexes.
  """
  @spec distance(t, t) :: non_neg_integer
  def distance(%Hex{} = a, %Hex{} = b) do
    Hex.distance(subtract(a, b))
  end

  @doc """
  Returns a new Hex representing the `direction`. Assuming "pointy"
  hexagon orientation, the 6 surrounding hexes can be thought of using compass
  directions, with the exception of "north" and "south".

  These directions can also be represented with a given range
  between 0 and 5, 0 representing "east" and rotating clockwise. 5
  representes "north_east".
  """
  @spec direction_offset(atom | non_neg_integer) :: t
  def direction_offset(direction)
      when is_integer(direction) and 0 <= direction and direction <= 5 do
    neighbor_directions = [
      :east,
      :south_east,
      :south_west,
      :west,
      :north_west,
      :north_east
    ]

    neighbor_directions
    |> Enum.at(direction)
    |> direction_offset()
  end

  def direction_offset(direction) do
    case direction do
      :east -> Hex.create!(1, -1, 0)
      :south_east -> Hex.create!(0, -1, 1)
      :south_west -> Hex.create!(-1, 0, 1)
      :west -> Hex.create!(-1, 1, 0)
      :north_west -> Hex.create!(0, 1, -1)
      :north_east -> Hex.create!(1, 0, -1)
      _ -> :error
    end
  end

  @doc """
  Returns the direct neighboring Hex in any given direction.
  """
  @spec neighbor(t, atom) :: t
  def neighbor(%Hex{} = hex, direction) do
    add(hex, direction_offset(direction))
  end

  @doc """
  Returns all neighboring Hexes, starting with the "eastern" Hex and rotating clockwise.
  """
  @spec neighbors(t) :: list
  def neighbors(%Hex{} = hex) do
    Enum.map(0..5, &neighbor(hex, &1))
  end

  @doc """
  Returns a boolean if the two Hexes are immediate neighbor Hexes.
  """
  @spec neighbor?(t, t) :: boolean
  def neighbor?(%Hex{} = hex_a, %Hex{} = hex_b) do
    distance(hex_a, hex_b) == 1
  end

  @doc """
  Returns all neighboring Hexes within a given radius, starting with the outermost
  "East" `q` Hex-line, working descending through the `r` Hex-line.
  """
  @spec neighborhood(t, non_neg_integer) :: list
  def neighborhood(%Hex{} = hex, radius) do
    radius_range = radius..-radius

    for dq <- radius_range,
        dr <-
          Enum.max([-radius, -dq - radius])..Enum.min([radius, -dq + radius]) do
      Hex.add(hex, Hex.create!(dq, dr, -dq - dr))
    end
  end

  @doc """
  Returns a new Hex representing the diagonal offset. Assuming "pointy"
  hexagon orientation, the 6 diagonal hexes can be represented using compass
  directions, with the exception of "east" and "west".

  These directions can also be represented with a given range
  between 0 and 5, 0 representing "north" and rotating clockwise. 5
  representes "north_west".
  """
  @spec diagonal_offset(atom | non_neg_integer) :: t
  def diagonal_offset(direction)
      when is_integer(direction) and 0 <= direction and direction <= 5 do
    diagonal_directions = [
      :north,
      :north_east,
      :south_east,
      :south,
      :south_west,
      :north_west
    ]

    diagonal_directions
    |> Enum.at(direction)
    |> diagonal_offset()
  end

  def diagonal_offset(direction) do
    case direction do
      :north -> Hex.create!(1, 1, -2)
      :north_east -> Hex.create!(2, -1, -1)
      :south_east -> Hex.create!(1, -2, 1)
      :south -> Hex.create!(-1, -1, 2)
      :south_west -> Hex.create!(-2, 1, 1)
      :north_west -> Hex.create!(-1, 2, -1)
      _ -> :error
    end
  end

  @doc """
  Returns the diagonal neighboring Hex in any given direction.
  """
  @spec diagonal_neighbor(t, atom) :: t
  def diagonal_neighbor(%Hex{} = hex, direction) do
    add(hex, diagonal_offset(direction))
  end

  @doc """
  Returns all diagonal neighboring Hexes, starting with the "northen" Hex.
  """
  @spec diagonal_neighbors(t) :: list
  def diagonal_neighbors(%Hex{} = hex) do
    Enum.map(0..5, &diagonal_neighbor(hex, &1))
  end

  @doc """
  Compates two Hexes, returns a boolean indicating whether the Hexes
  are equal.
  """
  @spec equal?(t, t) :: boolean
  def equal?(%Hex{} = a, %Hex{} = b) do
    a.q == b.q and a.r == b.r and a.s == b.s
  end

  @doc """
  Inverse of Hex.equal?/2.

  Compares two Hexes, returns a boolean indicating whether the Hexes
  are not equal.
  """
  @spec not_equal?(t, t) :: boolean
  def not_equal?(%Hex{} = a, %Hex{} = b) do
    not equal?(a, b)
  end
end
