defmodule Aoc202403_test do
  use ExUnit.Case

  import Aoc202403

  describe "part1/0" do
    test "returns sum of mul's" do
      assert 160672468 == part1()
    end
  end

  describe "part2/0" do
    test "returns sum of enabled mul's" do
      assert 84893551 == part2()
    end
  end
end
