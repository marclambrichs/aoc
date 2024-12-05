defmodule Aoc202404 do
  @directions [{-1, 0}, {1, 0}, {0, -1}, {0, 1}, {-1, -1}, {-1, 1}, {1, 1}, {1, -1}]

  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1() do
    matrix()
    |> substrings()
    |> Enum.filter(&(&1 == "XMAS"))
    |> Enum.count()
  end

  def part2() do
    matrix()
    |> substrings(:part2)
    |> Enum.count()
  end

  defp matrix() do
    Aoc.input_lines(__MODULE__)
    |> Enum.to_list()
  end

  defp element(_grid, i, _j) when i < 0, do: []
  defp element(_grid, _i, j) when j < 0, do: []

  defp element(grid, i, j) do
    length = String.length(Enum.at(grid, 0)) - 1
    if i > length or j > length, do: [], else: [String.at(Enum.at(grid, j), i)]
  end

  ########## Part 1 ##########

  @doc """
  Get all possible substrings for your grid
  """
  def substrings(grid) do
    for i <- 0..(length(grid) - 1), j <- 0..(String.length(Enum.at(grid, 0)) - 1) do
      substrings(grid, i, j)
    end
    |> List.flatten()
  end

  @doc """
  Get all possible substrings for coordinate (i, j) in grid.
  """
  def substrings(grid, i, j) do
    Enum.map(@directions, &substring(grid, i, j, &1))
    |> Enum.filter(&(length(&1) == 4))
    |> Enum.map(&Enum.join/1)
  end

  @doc """
  Get substring for coordinate (i, j) in particular direction
  """
  def substring(grid, i, j, direction) do
    Enum.reduce(0..3, [], fn x, acc ->
      coord = update_direction(direction, x)
      acc ++ element(grid, i + elem(coord, 0), j + elem(coord, 1))
    end)
  end

  defp update_direction({a, b}, factor), do: {a * factor, b * factor}

  ########## Part 2 ##########
  def substrings(grid, :part2) do
    for i <- 0..(length(grid) - 1), j <- 0..(String.length(Enum.at(grid, 0)) - 1) do
      substrings(grid, i, j, :part2)
    end
    |> Enum.filter(&(length(&1) == 2))
  end

  def substrings(grid, i, j, :part2) do
    ([element(grid, i - 1, j + 1) ++ element(grid, i, j) ++ element(grid, i + 1, j - 1)] ++
       [element(grid, i - 1, j - 1) ++ element(grid, i, j) ++ element(grid, i + 1, j + 1)])
    |> Enum.map(&Enum.join/1)
    |> Enum.filter(&(&1 == "SAM" or &1 == "MAS"))
  end
end
