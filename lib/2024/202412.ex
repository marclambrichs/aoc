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
    garden = garden(example(0))

    partitions(garden)
    |> Enum.map(fn region ->
      area(region) *
        (Enum.map(region, &(corners(:inner, garden, &1) + corners(:outer, garden, &1)))
         |> Enum.sum())
    end)
    |> Enum.sum()
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

      3 ->
        """
        AAAA
        BBCD
        BBCC
        EEEC
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
      Enum.reduce(0..(length(Enum.at(matrix, row)) - 1), acc, fn col, acc ->
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
  def corners(:outer, garden, {a, b}) do
    [{{0, -1}, {-1, 0}}, {{-1, 0}, {0, 1}}, {{0, 1}, {1, 0}}, {{1, 0}, {0, -1}}]
    |> Enum.map(fn {{a1, b1}, {a2, b2}} -> {{a + a1, b + b1}, {a + a2, b + b2}} end)
    |> Enum.map(fn {x, y} ->
      Map.get(garden, x) != Map.get(garden, {a, b}) and
        Map.get(garden, y) != Map.get(garden, {a, b})
    end)
    |> Enum.filter(& &1)
    |> Enum.count()
  end

  def corners(:inner, garden, {a, b}) do
    [
      {{0, -1}, {-1, 0}, {-1, -1}},
      {{-1, 0}, {0, 1}, {-1, 1}},
      {{0, 1}, {1, 0}, {1, 1}},
      {{1, 0}, {0, -1}, {1, -1}}
    ]
    |> Enum.map(fn {{a1, b1}, {a2, b2}, {a3, b3}} ->
      {{a + a1, b + b1}, {a + a2, b + b2}, {a + a3, b + b3}}
    end)
    |> Enum.map(fn {x, y, diag} ->
      Map.get(garden, x) == Map.get(garden, {a, b}) and
        Map.get(garden, y) == Map.get(garden, {a, b}) and
        Map.get(garden, diag) != Map.get(garden, {a, b})
    end)
    |> Enum.filter(& &1)
    |> Enum.count()
  end
end
