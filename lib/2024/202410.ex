defmodule Aoc202410 do
  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1() do
    map()
  end

  def part2() do
    map()
  end

  def example() do
    """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def map(), do: Aoc.input_lines(__MODULE__) |> Enum.map(&String.split(&1, "", trim: true))


  ########## Part 2 ##########

end
