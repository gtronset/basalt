defmodule HoneycombTest do
  alias Honeycomb.Hex, as: Hex

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
end
