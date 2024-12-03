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
    |> calculate()
  end

  def memory() do
    Aoc.input_lines(__MODULE__)
    |> Enum.to_list()
  end

  defp parse(list) when is_list(list), do: Enum.flat_map(list, &parse(&1))

  defp parse(str) when is_binary(str) do
    Regex.scan(~r/mul\([0-9]+,[0-9]+\)/, str)
    |> List.flatten()
    |> Enum.map(&parse_with_mul(&1))
  end

  defp parse_with_mul(str), do: Regex.named_captures(~r/mul\((?<a>[0-9]+),(?<b>[0-9]+)\)/, str)

  defp calculate(list) do
    Enum.map(list, fn %{"a" => a, "b" => b} -> String.to_integer(a) * String.to_integer(b) end)
    |> Enum.sum()
  end

  defp conditional_parse(list) do
    Enum.flat_map(list, &String.split(&1, ~r/do\(\)|don't\(\)/, include_captures: true))
    |> parse_with_enablers()
  end

  defp parse_with_enablers(list, bool \\ true)
  defp parse_with_enablers([], _), do: []

  defp parse_with_enablers([h | t] = list, bool) do
    case h do
      "do()" -> execute(t, true) ++ parse_with_enablers(tl(t), true)
      "don't()" -> parse_with_enablers(t, false)
      _ -> execute(list, bool) ++ parse_with_enablers(t, bool)
    end
  end

  defp execute([], _), do: []

  defp execute([h | _t], true), do: parse(h)

  defp execute([_h | _t], false), do: []
end
