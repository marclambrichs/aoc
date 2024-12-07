defmodule Aoc202407_test do
  use ExUnit.Case

  import Aoc202407

  describe "part1/0" do
    test "returns sum calibrations" do
      assert 2_654_749_936_343 == part1()
    end
  end

  describe "part2/0" do
    test "returns sum of enabled mul's" do
      assert 124_060_392_153_684 == part2()
    end
  end
end
