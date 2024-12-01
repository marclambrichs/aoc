defmodule Aoc202401_test do
  use ExUnit.Case

  describe "part1/1" do
    test "returns total of distances" do
      assert Aoc202401.part1() == 1_646_452
    end
  end

  describe "part2/1" do
    test "returns similarity score" do
      assert Aoc202401.part2() == 23_609_874
    end
  end
end
