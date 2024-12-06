defmodule Aoc202405 do
  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1() do
    {updates, rules} = initial()

    Enum.filter(updates, &check_update(&1, rules))
    |> Enum.map(&middle/1)
    |> Enum.sum()
  end

  def part2() do
    {updates, rules} = initial()

    Enum.filter(updates, &(check_update(&1, rules) == false))
    |> Enum.map(fn update ->
      Enum.sort(update, &(&1 not in Map.get(rules, &2)))
    end)
    |> Enum.map(&middle/1)
    |> Enum.sum()
  end

  def initial() do
    {rules, updates} =
      Enum.split_while(Aoc.input_lines(__MODULE__) |> Enum.to_list(), &(&1 != ""))

    {updates
     |> Enum.drop(1)
     |> Enum.map(&String.split(&1, ","))
     |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end)), parse_rules(rules)}
  end

  def parse_rules(rules) do
    Enum.map(rules, &Regex.named_captures(~r{(?<a>\d+)\|(?<b>\d+)}, &1))
    |> Enum.reduce(%{}, fn %{"a" => a, "b" => b}, acc ->
      Map.update(acc, String.to_integer(a), [String.to_integer(b)], fn list ->
        list ++ [String.to_integer(b)]
      end)
    end)
  end

  def check_update(list, rules) do
    Enum.chunk_every(list, 2, 1, :discard)
    |> Enum.reduce_while(true, fn [left, right], _ ->
      if right in Map.get(rules, left) do
        {:cont, true}
      else
        {:halt, false}
      end
    end)
  end

  def middle(update) do
    Enum.at(update, div(length(update), 2))
  end
end
