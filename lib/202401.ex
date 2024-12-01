defmodule Aoc202401 do
  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1() do
    read_notes()
    |> Enum.map(&Enum.sort/1)
    |> compare_notes()
  end

  def part2() do
    [list_a, list_b] = read_notes()

    Enum.map(list_a, fn a -> a * (Enum.filter(list_b, &(&1 == a)) |> Enum.count()) end)
    |> Enum.sum()
  end

  def read_notes do
    Aoc.input_lines(__MODULE__)
    |> Stream.map(&String.split/1)
    |> Stream.map(&List.to_tuple/1)
    |> Enum.unzip()
    |> then(fn {a, b} ->
      [Enum.map(a, &String.to_integer/1), Enum.map(b, &String.to_integer/1)]
    end)
  end

  def compare_notes([list_a, list_b]) do
    Enum.zip_reduce(list_a, list_b, 0, fn a, b, acc -> abs(a - b) + acc end)
  end
end
