defmodule Aoc202410 do
  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1() do
    #    map = example()
    map = map()

    trailheads(map)
    |> Enum.map(&walk(&1, map))
    |> Enum.map(&(List.flatten(&1) |> Enum.uniq()))
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end

  def part2() do
    #      map = example()
    map = map()

    trailheads(map)
    |> Enum.map(&walk(:part2, &1, map))
    |> List.flatten()
    |> Enum.count()
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
    |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))
  end

  def map(),
    do:
      Aoc.input_lines(__MODULE__)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))

  def trailheads(list) do
    for i <- 0..(length(list) - 1),
        j <- 0..(length(Enum.at(list, 0)) - 1),
        Enum.at(Enum.at(list, i), j) == 0,
        into: [] do
      {i, j}
    end
  end

  def neighbours({x, y}, matrix) do
    max = length(Enum.at(matrix, 0))

    for {i, j} <- [{-1, 0}, {0, 1}, {1, 0}, {0, -1}] do
      {x + i, y + j}
    end
    |> Enum.filter(fn {x, y} -> x >= 0 and x < max and y >= 0 and y < max end)
    |> Enum.filter(&(height(&1, matrix) == height({x, y}, matrix) + 1))
  end

  def height({x, y}, map), do: Enum.at(Enum.at(map, x), y)

  def walk(coord, matrix) do
    case height(coord, matrix) do
      9 ->
        coord

      _h ->
        neighbours(coord, matrix)
        |> Enum.map(&walk(&1, matrix))
    end
  end

  ########## Part 2 ##########
  def walk(:part2, coord, matrix) do
    case height(coord, matrix) do
      9 ->
        1

      _h ->
        neighbours(coord, matrix)
        |> Enum.map(&walk(:part2, &1, matrix))
    end
  end
end
