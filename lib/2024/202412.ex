defmodule Aoc202412 do
  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def timer(:part1), do: :timer.tc(__MODULE__, :part1, [])
  def timer(:part2), do: :timer.tc(__MODULE__, :part2, [])

  def part1() do
    garden(example(0))
    |> partitions()
    |> Enum.map(fn region -> area(region) * perimeter(region) end)
    |> Enum.sum()
  end

  def part2() do
    example()
  end

  def example(nr \\ 0) do
    case nr do
      0 ->
        garden()

      1 ->
        """
        RRRRIICCFF
        RRRRIICCCF
        VVRRRCCFFF
        VVRCCCJFFF
        VVVVCJJCFE
        VVIVCCJJEE
        VVIIICJJEE
        MIIIIIJJEE
        MIIISIJEEE
        MMMISSJEEE
        """
        |> String.trim()
        |> String.split("\n")

      2 ->
        """
        OOOOO
        OXOXO
        OOOOO
        OXOXO
        OOOOO
        """
        |> String.trim()
        |> String.split("\n")
    end
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def garden(),
    do: Aoc.input_lines(__MODULE__)

  def garden(matrix) do
    Enum.reduce(0..(length(matrix) - 1), %{}, fn row, acc ->
      Enum.reduce(0..(length(matrix) - 1), acc, fn col, acc ->
        Map.put(acc, {row, col}, type({row, col}, matrix))
      end)
    end)
  end

  def type({x, y}, matrix), do: Enum.at(Enum.at(matrix, x), y)

  def partitions(garden) do
    Enum.reduce(garden, [], fn {point, type}, acc ->
      if point in List.flatten(acc) do
        acc
      else
        connections = connections(garden, point, type, [])
        [connections | acc]
      end
    end)
  end

  def connections(garden, {x, y} = point, type, neighbours) do
    if Map.get(garden, point) == type and point not in neighbours do
      Enum.reduce([{0, 1}, {-1, 0}, {0, -1}, {1, 0}], [point | neighbours], fn {a, b}, acc ->
        connections(garden, {x + a, y + b}, type, acc)
      end)
    else
      neighbours
    end
  end

  def touches({a, b}, region) do
    [{-1, 0}, {0, -1}, {0, 1}, {1, 0}]
    |> Enum.map(fn {i, j} -> {a + i, b + j} end)
    |> Enum.filter(&(&1 in region))
  end

  def area(region), do: Enum.count(region)

  def perimeter(region) do
    Enum.map(region, &(4 - Enum.count(touches(&1, region)))) |> Enum.sum()
  end

  ########## Part 2 ##########
end
