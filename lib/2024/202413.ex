defmodule Aoc202413 do
  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def timer(:part1), do: :timer.tc(__MODULE__, :part1, [])
  def timer(:part2), do: :timer.tc(__MODULE__, :part2, [])

  def part1() do
    example(0)
    |> parse_machines()
    |> Enum.map(&count_tokens(&1))
    |> List.flatten()
    |> Enum.sum()
  end

  def part2() do

  end

  def example(nr \\ 0) do
    case nr do
      0 ->
        machines()
        |> Enum.chunk_every(3, 4)

      1 ->
        """
        Button A: X+94, Y+34
        Button B: X+22, Y+67
        Prize: X=8400, Y=5400

        Button A: X+26, Y+66
        Button B: X+67, Y+21
        Prize: X=12748, Y=12176

        Button A: X+17, Y+86
        Button B: X+84, Y+37
        Prize: X=7870, Y=6450

        Button A: X+69, Y+23
        Button B: X+27, Y+71
        Prize: X=18641, Y=10279
        """
        |> String.split("\n", trim: true)
        |> Enum.chunk_every(3)
    end
  end

  def machines(),
    do: Aoc.input_lines(__MODULE__)

  def parse_machines(machines) do
    Enum.map(
      machines,
      &Enum.map(&1, fn row ->
        [[_, x], [_, y]] = Regex.scan(~r/[XY][+=](\d+)/, row)

        {String.to_integer(x), String.to_integer(y)}
      end)
    )
  end

  def count_tokens([{a_x, a_y}, {b_x, b_y}, {prize_x, prize_y}]) do
    for a <- 0..100,
        b <- 0..100,
        a * a_x + b * b_x == prize_x,
        a * a_y + b * b_y == prize_y do
      a * 3 + b
    end
  end

  ########## Part 2 ##########
end
