defmodule Aoc202404_test do
  use ExUnit.Case

  import Aoc202404

  describe "part1/0" do
    test "returns" do
    end
  end

  describe "part2/0" do
    test "returns" do
    end
  end

  def grid() do
    """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """
    |> String.trim()
    |> String.split(~r{[\s\n]})
  end
end
