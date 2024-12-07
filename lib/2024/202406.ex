defmodule Aoc202406 do
  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1() do
    matrix =
#      grid()
      matrix()
      |> add_coordinates()

    [{coord, cursor}] = start_walk(matrix)
    step(cursor, coord, matrix)
    |> Enum.filter(
      fn {{_a, _b}, char} -> String.match?(char, ~r/X/) end
    )
    |> Enum.count()
  end

  def part2() do
  end

  def grid() do
    """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """
    |> String.trim()
    |> String.split(~r{[\n]})
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def matrix(), do: Aoc.input_lines(__MODULE__) |> Enum.map(&String.split(&1, ""))

  def add_coordinates(matrix) when is_list(matrix) do
    for {row, i} <- Enum.with_index(matrix), {char, j} <- Enum.with_index(row), into: %{} do
      {{i, j}, char}
    end
  end

  def start_walk(matrix) do
    Enum.filter(
      matrix,
      fn {{_a, _b}, char} -> String.match?(char, ~r/(?<cursor>[\^>v<])/) end
    )
  end

  def step("<", {a, 0}, matrix), do: Map.put(matrix, {a, 0}, "X")

  def step("<", {a, b}, matrix) do
    if Map.fetch!(matrix, {a, b - 1}) == "#" do
      step("^", {a - 1, b}, Map.put(matrix, {a, b}, "X"))
    else
      step("<", {a, b - 1}, Map.put(matrix, {a, b}, "X"))
    end
  end

  def step("v", {a, b}, matrix) do
    cond do
      matrix |> Enum.count() |> :math.sqrt() == a + 1 ->
        matrix

      Map.fetch!(matrix, {a + 1, b}) == "#" ->
        step("<", {a, b - 1}, Map.put(matrix, {a, b}, "X"))

      true ->
        step("v", {a + 1, b}, Map.put(matrix, {a, b}, "X"))
    end
  end

  def step("^", {0, b}, matrix), do: Map.put(matrix, {0, b}, "X")

  def step("^", {a, b}, matrix) do
    cond do
      Map.fetch!(matrix, {a - 1, b}) == "#" ->
        step(">", {a, b + 1}, Map.put(matrix, {a, b}, "X"))

      true ->
        step("^", {a - 1, b}, Map.put(matrix, {a, b}, "X"))
    end
  end

  def step(">", {a, b}, matrix) do
    cond do
      matrix |> Enum.count() |> :math.sqrt() == b + 1 ->
        matrix

      Map.fetch!(matrix, {a, b + 1}) == "#" ->
        step("v", {a + 1, b}, Map.put(matrix, {a, b}, "X"))

      true ->
        step(">", {a, b + 1}, Map.put(matrix, {a, b}, "X"))
    end
  end
end
