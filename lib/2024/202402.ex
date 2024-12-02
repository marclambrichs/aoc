defmodule Aoc202402 do
  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1() do
    reports()
    |> Enum.map(&safe?/1)
    |> Enum.filter(&(&1 == true))
    |> Enum.count()
  end

  def part2() do
    reports()
    |> Enum.map(&(safe?(&1) or safe?(&1, :dampener)))
    |> Enum.filter(&(&1 == true))
    |> Enum.count()
  end

  defp reports do
    Aoc.input_lines(__MODULE__)
    |> Stream.map(&String.split/1)
    |> Stream.map(&Enum.map(&1, fn x -> String.to_integer(x) end))
  end

  def safe?(list) do
    Enum.zip(list -- [List.last(list)], list -- [List.first(list)])
    |> Enum.map(fn {a, b} -> a - b end)
    |> then(fn x ->
      (Enum.all?(x, &(&1 > 0)) or Enum.all?(x, &(&1 < 0))) and
        Enum.min_by(x, &abs/1) |> abs() >= 1 and
        Enum.max_by(x, &abs/1) |> abs() <= 3
    end)
  end

  def dampener(list) do
    for idx <- 0..(length(list) - 1), do: List.delete_at(list, idx)
  end

  def safe?(list, dampener) do
    apply(__MODULE__, dampener, [list])
    |> Enum.map(&safe?/1)
    |> Enum.any?(&(&1 == true))
  end
end
