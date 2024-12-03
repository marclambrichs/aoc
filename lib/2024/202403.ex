defmodule Aoc202403 do
  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1() do
    memory()
    |> parse()
    |> calculate()
  end

  def part2() do
    memory()
    |> conditional_parse()
  end

  def memory() do
    Aoc.input_lines(__MODULE__)
    |> Enum.to_list()
  end

  def parse(list) when is_list(list), do: Enum.flat_map(list, &parse(&1))

  def parse(str) when is_binary(str) do
    Regex.scan(~r/mul\([0-9]+,[0-9]+\)/, str)
    |> List.flatten()
    |> Enum.map(&parse_instructions(&1))
  end

  def parse_instructions(str), do: Regex.named_captures(~r/mul\((?<a>[0-9]+),(?<b>[0-9]+)\)/, str)

  def calculate(list) do
    Enum.map(list, fn %{"a" => a, "b" => b} -> String.to_integer(a) * String.to_integer(b) end)
    |> Enum.sum()
  end

  def conditional_parse(list) do
    Enum.flat_map(list, &String.split(&1, ~r/do\(\)|don't\(\)/, include_captures: true))
    |> parse_list()
  end

  def parse_list(list, bool \\ true)
  def parse_list([], _), do: 0

  def parse_list([h | t] = list, bool) do
    case h do
      "do()" -> execute(t, true) + parse_list(tl(t), true)
      "don't()" -> parse_list(t, false)
      _ -> execute(list, bool) + parse_list(t, bool)
    end
  end

  def execute([], _), do: 0

  def execute([h | _t], true), do: parse(h) |> calculate()

  def execute([_h | _t], false), do: 0
end
