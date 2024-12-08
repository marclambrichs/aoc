defmodule Aoc202408 do
  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1() do
    roofs()
    # example()
    |> antennas()
    |> Map.values()
    |> Enum.map(&antinodes(&1))
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.count()
  end

  def part2() do
    roofs()
    # example()
    |> antennas()
    |> Map.values()
    |> Enum.map(&antinodes(:part2, &1, 50))
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.count()
  end

  def example() do
    """
    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............
    """
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def roofs(), do: Aoc.input_lines(__MODULE__) |> Enum.map(&String.split(&1, "", trim: true))

  def antennas(roofs) do
    for i <- 0..(length(roofs) - 1),
        j <- 0..(length(Enum.at(roofs, 0)) - 1),
        String.match?(Enum.at(Enum.at(roofs, i), j), ~r/[0-9a-zA-Z]/),
        into: [] do
      [Enum.at(Enum.at(roofs, i), j), {i, j}]
    end
    |> Enum.reduce(%{}, fn [antenna, coord], acc ->
      if Map.has_key?(acc, antenna),
        do: Map.put(acc, antenna, Map.fetch!(acc, antenna) ++ [coord]),
        else: Map.put(acc, antenna, [coord])
    end)
  end

  def antinodes(list, max \\ 50) do
    for coord1 <- list, coord2 <- list -- [coord1], uniq: true do
      [coord1, coord2] |> List.keysort(0)
    end
    |> Enum.map(fn [coord1, coord2] ->
      {dx, dy} = {elem(coord2, 0) - elem(coord1, 0), elem(coord2, 1) - elem(coord1, 1)}

      [
        {elem(coord1, 0) - dx, elem(coord1, 1) - dy},
        {elem(coord2, 0) + dx, elem(coord2, 1) + dy}
      ]
    end)
    |> List.flatten()
    |> Enum.filter(fn {x, y} -> x >= 0 and x < max and y >= 0 and y < max end)
  end

  ########## Part 2 ##########
  def antinodes(:part2, list, max) do
    for coord1 <- list, coord2 <- list -- [coord1], uniq: true do
      [coord1, coord2] |> List.keysort(0)
    end
    |> Enum.map(fn [coord1, coord2] ->
      {dx, dy} = {elem(coord2, 0) - elem(coord1, 0), elem(coord2, 1) - elem(coord1, 1)}
      Enum.map(-max..max, &{elem(coord1, 0) + &1 * dx, elem(coord1, 1) + &1 * dy})
    end)
    |> List.flatten()
    |> Enum.filter(fn {x, y} -> x >= 0 and x < max and y >= 0 and y < max end)
  end
end
