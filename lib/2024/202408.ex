defmodule Aoc202408 do
  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1() do
    roofs()
    |> antennas()
  end

  def part2() do
    roofs()
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
end
