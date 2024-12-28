defmodule Aoc202414 do
#  @width 11
#  @height 7
  @width 101
  @height 103

  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def timer(:part1), do: :timer.tc(__MODULE__, :part1, [])
  def timer(:part2), do: :timer.tc(__MODULE__, :part2, [])

  def part1() do
    example(0)
    |> Enum.map(fn row ->
      [[_, px, py], [_, vx, vy]] = Regex.scan(~r/[pv]=(?<x>[-+]?\d+),(?<y>[-+]?\d+)/, row)

      %{
        px: String.to_integer(px),
        py: String.to_integer(py),
        vx: String.to_integer(vx),
        vy: String.to_integer(vy)
      }
    end)
    |> steps()
    |> Enum.group_by(&quadrant(&1))
    |> Enum.reduce(1, fn
      {quadrant, list}, acc when quadrant > 0 -> acc * Enum.count(list)
      {quadrant, _list}, acc when quadrant == 0 -> acc
    end)
  end

  def part2() do
    example(0)
    |> Enum.map(fn row ->
      [[_, px, py], [_, vx, vy]] = Regex.scan(~r/[pv]=(?<x>[-+]?\d+),(?<y>[-+]?\d+)/, row)

      %{
        px: String.to_integer(px),
        py: String.to_integer(py),
        vx: String.to_integer(vx),
        vy: String.to_integer(vy)
      }
    end)
  end

  def example(nr \\ 0) do
    case nr do
      0 ->
        robots()

      1 ->
        """
        p=0,4 v=3,-3
        p=6,3 v=-1,-3
        p=10,3 v=-1,2
        p=2,0 v=2,-1
        p=0,0 v=1,3
        p=3,0 v=-2,-2
        p=7,6 v=-1,-3
        p=3,0 v=-1,-2
        p=9,3 v=2,3
        p=7,3 v=-1,2
        p=2,4 v=2,-3
        p=9,5 v=-3,-3
        """
        |> String.split("\n", trim: true)
    end
  end

  def robots(),
    do: Aoc.input_lines(__MODULE__)

  def steps(robots) do
    Enum.reduce(robots, [], fn robot, acc ->
      hor = rem(robot.vx + @width, @width)
      vert = rem(robot.vy + @height, @height)
      acc ++ [{rem(robot.py + 100 * vert, @height), rem(robot.px + 100 * hor, @width)}]
    end)
  end

  def quadrant(position) do
    case position do
      {x, y} when x < div(@height, 2) and y < div(@width, 2) -> 1
      {x, y} when x < div(@height, 2) and y > div(@width, 2) -> 2
      {x, y} when x > div(@height, 2) and y < div(@width, 2) -> 3
      {x, y} when x > div(@height, 2) and y > div(@width, 2) -> 4
      _ -> 0
    end
  end

  ########## Part 2 ##########

end
