defmodule Aoc202411 do
  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1() do
    stones()
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
    |> blink(25)
    |> Map.values()
    |> Enum.sum()
  end

  def part2() do
    stones()
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
    |> blink(75)
    |> Map.values()
    |> Enum.sum()
  end

  def example() do
    """
    125 17
    """
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def stones(),
    do:
      Aoc.input_lines(__MODULE__)
      |> Enum.to_list()
      |> Stream.flat_map(&String.split(&1, " ", trim: true))
      |> Stream.map(&String.to_integer/1)

  def blink(0), do: [1]

  def blink(stone) when is_integer(stone) do
    digits = digits(stone)

    case rem(digits, 2) do
      0 ->
        left = div(stone, Integer.pow(10, div(digits, 2)))
        right = rem(stone, Integer.pow(10, div(digits, 2)))
        [left, right]

      _ ->
        [stone * 2024]
    end
  end

  def digits(stone), do: String.length(Integer.to_string(stone))

  ########## Part 2 ##########
  def blink(stones, 0) when is_map(stones), do: stones

  def blink(stones, times) when is_map(stones) do
    Enum.reduce(stones, %{}, fn {nr, count}, acc ->
      Enum.reduce(blink(nr), acc, fn stone, acc ->
        Map.update(acc, stone, count, fn prev -> prev + count end)
      end)
    end)
    |> blink(times - 1)
  end
end
