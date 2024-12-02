defmodule Aoc202402_test do
  use ExUnit.Case

  import Aoc202402

  describe "part1/0" do
    test "returns nr of valid reports" do
      assert 314 == part1()
    end
  end

  describe "part2/0" do
    test "returns nr of valid reports" do
      assert 373 == part2()
    end
  end

  describe "safe/1" do
    test "returns boolean if list is safe" do
      assert true == safe?([7, 6, 4, 2, 1])
      assert false == safe?([1, 2, 7, 8, 9])
      assert false == safe?([9, 7, 6, 2, 1])
      assert false == safe?([1, 3, 2, 4, 5])
      assert false == safe?([8, 6, 4, 4, 1])
      assert true == safe?([1, 3, 6, 7, 9])
    end
  end

  describe "safe/2" do
    test "returns boolean if list with dampener is safe" do
      assert true == safe?([7, 6, 4, 2, 1], :dampener)
      assert false == safe?([1, 2, 7, 8, 9], :dampener)
      assert false == safe?([9, 7, 6, 2, 1], :dampener)
      assert true == safe?([1, 3, 2, 4, 5], :dampener)
      assert true == safe?([8, 6, 4, 4, 1], :dampener)
      assert true == safe?([1, 3, 6, 7, 9], :dampener)
      assert true == safe?([61, 59, 56, 53, 50, 49, 46], :dampener)
      assert true == safe?([35, 34, 31, 34, 30], :dampener)
      assert false == safe?([70, 70, 65, 62, 60], :dampener)
    end
  end
end
