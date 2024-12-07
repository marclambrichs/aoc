defmodule Aoc202406 do
  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1() do
    matrix =
      matrix()
      |> add_coordinates()

    [{coord, cursor}] = start_walk(matrix)

    traverse(cursor, coord, matrix)
    |> Enum.filter(fn {{_a, _b}, char} -> String.match?(char, ~r/X/) end)
    |> Enum.count()
  end

  def part2() do
  end

  def matrix(), do: Aoc.input_lines(__MODULE__) |> Enum.map(&String.split(&1, ""))

  def add_coordinates(matrix) when is_list(matrix) do
    for {row, i} <- Enum.with_index(matrix), {char, j} <- Enum.with_index(row), into: %{} do
      {{i, j}, char}
    end
  end

  def start_walk(matrix) do
    Enum.filter(matrix, fn {{_a, _b}, char} -> String.match?(char, ~r/[\^>v<]/) end)
  end

  def traverse("<", {a, 0}, matrix), do: Map.put(matrix, {a, 0}, "X")

  def traverse("<", {a, b}, matrix) do
    if Map.fetch!(matrix, {a, b - 1}) == "#" do
      traverse("^", {a - 1, b}, Map.put(matrix, {a, b}, "X"))
    else
      traverse("<", {a, b - 1}, Map.put(matrix, {a, b}, "X"))
    end
  end

  def traverse("v", {a, b}, matrix) do
    cond do
      matrix |> Enum.count() |> :math.sqrt() == a + 1 ->
        matrix

      Map.fetch!(matrix, {a + 1, b}) == "#" ->
        traverse("<", {a, b - 1}, Map.put(matrix, {a, b}, "X"))

      true ->
        traverse("v", {a + 1, b}, Map.put(matrix, {a, b}, "X"))
    end
  end

  def traverse("^", {0, b}, matrix), do: Map.put(matrix, {0, b}, "X")

  def traverse("^", {a, b}, matrix) do
    cond do
      Map.fetch!(matrix, {a - 1, b}) == "#" ->
        traverse(">", {a, b + 1}, Map.put(matrix, {a, b}, "X"))

      true ->
        traverse("^", {a - 1, b}, Map.put(matrix, {a, b}, "X"))
    end
  end

  def traverse(">", {a, b}, matrix) do
    cond do
      matrix |> Enum.count() |> :math.sqrt() == b + 1 ->
        matrix

      Map.fetch!(matrix, {a, b + 1}) == "#" ->
        traverse("v", {a + 1, b}, Map.put(matrix, {a, b}, "X"))

      true ->
        traverse(">", {a, b + 1}, Map.put(matrix, {a, b}, "X"))
    end
  end
end
