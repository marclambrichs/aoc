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
    example(0)
    |> parse_machines()
    |> Enum.map(fn [{ax, ay}, {bx, by}, {px, py}] ->
      count_tokens(:b, [
        {ax, ay},
        {bx, by},
        {px + 10_000_000_000_000, py + 10_000_000_000_000}
      ])
    end)
    |> Enum.sum()
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

  def count_tokens([{ax, ay}, {bx, by}, {px, py}]) do
    for a <- 0..100,
        b <- 0..100,
        a * ax + b * bx == px,
        a * ay + b * by == py do
      a * 3 + b
    end
  end

  ########## Part 2 ##########
  @doc """
  ax * x + ay * y = px
  bx * x + by * y = py

  Determinant =
    | ax ay |
    | bx by |
  """
  def count_tokens(:b, [{ax, ay}, {bx, by}, {px, py}]) do
    determinant = ax * by - ay * bx
    det_x = px * by - bx * py
    det_y = ax * py - px * ay

    if rem(det_x, determinant) == 0 and rem(det_y, determinant) == 0 do
      div(det_x, determinant) * 3 + div(det_y, determinant)
    else
      0
    end
  end
end
