defmodule Aoc202404 do
  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1() do
    read()
  end

  def part2() do
    read()
  end

  def read() do
    Aoc.input_lines(__MODULE__)
    |> Enum.to_list()
  end

end
