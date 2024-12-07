defmodule Aoc202407 do
  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1() do
    calibrations()
    |> Enum.filter(fn {key, values} ->
      key in calculate(values)
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def part2() do
    calibrations()
    |> Enum.filter(fn {key, values} ->
      key in calculate(:part2, values)
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def calibrations() do
    for lines <- Aoc.input_lines(__MODULE__) |> Enum.to_list(), into: %{} do
      [key, values] = String.split(lines, ": ")
      {String.to_integer(key), values |> String.split(" ") |> Enum.map(&String.to_integer/1)}
    end
  end

  def calculate(list) do
    Enum.reduce(list, fn
      x, acc when is_list(acc) ->
        Enum.map(acc, &[&1 * x, &1 + x]) |> List.flatten()

      x, acc ->
        [acc * x, acc + x]
    end)
  end

  ########## Part 2 ##########
  def calculate(:part2, list) do
    Enum.reduce(list, fn
      x, acc when is_list(acc) ->
        Enum.map(acc, &[&1 * x, &1 + x, concat(&1, x)]) |> List.flatten()

      x, acc ->
        [acc * x, acc + x, concat(acc, x)]
    end)
  end

  def concat(a, b) do
    (Integer.to_string(a) <> Integer.to_string(b)) |> String.to_integer()
  end
end
