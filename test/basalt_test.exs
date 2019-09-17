defmodule BasaltTest do
  alias Basalt.Hex, as: Hex

  use ExUnit.Case, async: true
  doctest Hex

  describe "Hex.create!/3" do
    test "creates new hex with integer coordinates" do
      assert Hex.create!(1, 0, -1) == %Hex{q: 1, r: 0, s: -1}
    end

    test "creates new hex with scientific floating point coordinates" do
      assert Hex.create!(-1.0e-4, 1 - 1.0e-4, -1 + 2.0e-4) == %Hex{
               q: -1.0e-4,
               r: 1 - 1.0e-4,
               s: -1 + 2.0e-4
             }
    end

    test "raises error on invalid hex" do
      assert_raise ArgumentError, fn -> Hex.create!(1, 1, 1) end
    end
  end

  describe "Hex.create/3" do
    test "creates new hex with status" do
      assert {:ok, %Hex{q: 1, r: 1, s: -2}} = Hex.create(1, 1, -2)
    end

    test "raises error on invalid hex" do
      assert {:error, "invalid coordinates, constraint q + r + s = 0"} = Hex.create(1, 1, 1)
    end
  end

  describe "Hex.add/2" do
    test "returns a hex from adding two hexes together" do
      hex_a = Hex.create!(1, 1, -2)
      hex_b = Hex.create!(1, 0, -1)

      assert Hex.add(hex_a, hex_b) == %Hex{q: 2, r: 1, s: -3}
    end
  end

  describe "Hex.subtract/2" do
    test "returns a hex from subtracting two hexes" do
      hex_a = Hex.create!(1, 1, -2)
      hex_b = Hex.create!(1, 0, -1)

      assert Hex.subtract(hex_a, hex_b) == %Hex{q: 0, r: 1, s: -1}
    end
  end

  describe "Hex.scale/2" do
    test "returns a hex from scaling a Hex by multiplier `k`" do
      hex_a = Hex.create!(1, 1, -2)

      assert Hex.scale(hex_a, 2) == %Hex{q: 2, r: 2, s: -4}
    end
  end

  describe "Hex.length/2" do
    test "returns the length of a hex" do
      hex_a = Hex.create!(1, 1, -2)

      assert Hex.length(hex_a) == 2
    end
  end

  describe "Hex.distance/2" do
    test "returns the distance between two hexes" do
      hex_a = Hex.create!(1, 1, -2)
      hex_b = Hex.create!(3, -1, -2)

      assert Hex.distance(hex_a, hex_b) == 2
    end
  end

  describe "Hex.direction_offset/1" do
    test "returns the offset Hex of a given compass direction" do
      assert Hex.direction_offset(:east) == %Hex{q: 1, r: -1, s: 0}
      assert Hex.direction_offset(:south_east) == %Hex{q: 0, r: -1, s: 1}
      assert Hex.direction_offset(:south_west) == %Hex{q: -1, r: 0, s: 1}
      assert Hex.direction_offset(:west) == %Hex{q: -1, r: 1, s: 0}
      assert Hex.direction_offset(:north_west) == %Hex{q: 0, r: 1, s: -1}
      assert Hex.direction_offset(:north_east) == %Hex{q: 1, r: 0, s: -1}
      assert Hex.direction_offset("west") == :error
    end

    test "returns the offset Hex of a given numerical direction" do
      assert Hex.direction_offset(0) == %Hex{q: 1, r: -1, s: 0}
      assert Hex.direction_offset(1) == %Hex{q: 0, r: -1, s: 1}
      assert Hex.direction_offset(2) == %Hex{q: -1, r: 0, s: 1}
      assert Hex.direction_offset(3) == %Hex{q: -1, r: 1, s: 0}
      assert Hex.direction_offset(4) == %Hex{q: 0, r: 1, s: -1}
      assert Hex.direction_offset(5) == %Hex{q: 1, r: 0, s: -1}
    end
  end

  describe "Hex.neighbor/2" do
    test "returns the immediate neighbor in given compass direction" do
      hex_a = Hex.create!(1, 1, -2)

      assert Hex.neighbor(hex_a, :east) == %Hex{q: 2, r: 0, s: -2}
    end

    test "returns the immediate neighbor in given numerical direction" do
      hex_a = Hex.create!(1, 1, -2)

      assert Hex.neighbor(hex_a, 0) == %Hex{q: 2, r: 0, s: -2}
    end
  end

  describe "Hex.neighbors/1" do
    test "returns all immediate neighbors" do
      hex_a = Hex.create!(1, 1, -2)

      assert Hex.neighbors(hex_a) == [
               %Hex{q: 2, r: 0, s: -2},
               %Hex{q: 1, r: 0, s: -1},
               %Hex{q: 0, r: 1, s: -1},
               %Hex{q: 0, r: 2, s: -2},
               %Hex{q: 1, r: 2, s: -3},
               %Hex{q: 2, r: 1, s: -3}
             ]
    end
  end

  describe "Hex.diagonal_offset/1" do
    test "returns the offset Hex of a given compass direction" do
      assert Hex.diagonal_offset(:north) == %Hex{q: 1, r: 1, s: -2}
      assert Hex.diagonal_offset(:north_east) == %Hex{q: 2, r: -1, s: -1}
      assert Hex.diagonal_offset(:south_east) == %Hex{q: 1, r: -2, s: 1}
      assert Hex.diagonal_offset(:south) == %Hex{q: -1, r: -1, s: 2}
      assert Hex.diagonal_offset(:south_west) == %Hex{q: -2, r: 1, s: 1}
      assert Hex.diagonal_offset(:north_west) == %Hex{q: -1, r: 2, s: -1}
      assert Hex.diagonal_offset("south") == :error
    end

    test "returns the offset Hex of a given numerical direction" do
      assert Hex.diagonal_offset(0) == %Hex{q: 1, r: 1, s: -2}
      assert Hex.diagonal_offset(1) == %Hex{q: 2, r: -1, s: -1}
      assert Hex.diagonal_offset(2) == %Hex{q: 1, r: -2, s: 1}
      assert Hex.diagonal_offset(3) == %Hex{q: -1, r: -1, s: 2}
      assert Hex.diagonal_offset(4) == %Hex{q: -2, r: 1, s: 1}
      assert Hex.diagonal_offset(5) == %Hex{q: -1, r: 2, s: -1}
    end
  end

  describe "Hex.diagonal_neighbor/2" do
    test "returns the diagonal neighbor in given compass direction" do
      hex_a = Hex.create!(1, 1, -2)

      assert Hex.diagonal_neighbor(hex_a, :north_east) == %Hex{q: 3, r: 0, s: -3}
    end

    test "returns the diagonal neighbor in given numerical direction" do
      hex_a = Hex.create!(1, 1, -2)

      assert Hex.diagonal_neighbor(hex_a, 0) == %Hex{q: 2, r: 2, s: -4}
    end
  end

  describe "Hex.diagonal_neighbors/1" do
    test "returns all diagonal neighbors" do
      hex_a = Hex.create!(1, 1, -2)

      assert Hex.diagonal_neighbors(hex_a) == [
               %Hex{q: 2, r: 2, s: -4},
               %Hex{q: 3, r: 0, s: -3},
               %Hex{q: 2, r: -1, s: -1},
               %Hex{q: 0, r: 0, s: 0},
               %Hex{q: -1, r: 2, s: -1},
               %Hex{q: 0, r: 3, s: -3}
             ]
    end
  end

  describe "Hex.neighborhood/2" do
    test "returns all neighbors within a certain range" do
      hex_a = Hex.create!(1, -1, 0)

      assert Hex.neighborhood(hex_a, 2) == [
               %Hex{q: 3, r: -3, s: 0},
               %Hex{q: 3, r: -2, s: -1},
               %Hex{q: 3, r: -1, s: -2},
               %Hex{q: 2, r: -3, s: 1},
               %Hex{q: 2, r: -2, s: 0},
               %Hex{q: 2, r: -1, s: -1},
               %Hex{q: 2, r: 0, s: -2},
               %Hex{q: 1, r: -3, s: 2},
               %Hex{q: 1, r: -2, s: 1},
               %Hex{q: 1, r: -1, s: 0},
               %Hex{q: 1, r: 0, s: -1},
               %Hex{q: 1, r: 1, s: -2},
               %Hex{q: 0, r: -2, s: 2},
               %Hex{q: 0, r: -1, s: 1},
               %Hex{q: 0, r: 0, s: 0},
               %Hex{q: 0, r: 1, s: -1},
               %Hex{q: -1, r: -1, s: 2},
               %Hex{q: -1, r: 0, s: 1},
               %Hex{q: -1, r: 1, s: 0}
             ]
    end
  end

  describe "Hex.equal?/2" do
    test "returns true when two hexes are equal" do
      hex_a = Hex.create!(0, 1, -1)
      hex_b = Hex.create!(0, 1, -1)

      assert Hex.equal?(hex_a, hex_b) == true
    end

    test "returns false when two hexes are not equal" do
      hex_a = Hex.create!(1, 1, -2)
      hex_b = Hex.create!(1, 0, -1)

      assert Hex.equal?(hex_a, hex_b) == false
    end
  end

  describe "Hex.not_equal?/2" do
    test "returns false when two hexes are equal" do
      hex_a = Hex.create!(0, 1, -1)
      hex_b = Hex.create!(0, 1, -1)

      assert Hex.not_equal?(hex_a, hex_b) == false
    end

    test "returns true when two hexes are not equal" do
      hex_a = Hex.create!(1, 1, -2)
      hex_b = Hex.create!(1, 0, -1)

      assert Hex.not_equal?(hex_a, hex_b) == true
    end
  end
end
