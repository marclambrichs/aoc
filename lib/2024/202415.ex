defmodule Aoc202415 do
  @box "O"
  @empty "."
  @robot "@"
  @wall "#"
  @lbox "["
  @rbox "]"

  @up {0, -1}
  @right {1, 0}
  @down {0, 1}
  @left {-1, 0}

  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def timer(:part1), do: :timer.tc(__MODULE__, :part1, [])
  def timer(:part2), do: :timer.tc(__MODULE__, :part2, [])

  def part1() do
    input =
      Enum.reduce(input(), {[], []}, fn x, {xs, ys} ->
        if x == "", do: {ys, xs}, else: {[x | xs], ys}
      end)

    [commands, matrix, start] = parse(:part1, input)
    [_end, result] = execute(commands, matrix, start)
    sum_gps(result, @box)
  end

  def part2() do
    input =
      Enum.reduce(input(), {[], []}, fn x, {xs, ys} ->
        if x == "", do: {ys, xs}, else: {[x | xs], ys}
      end)

    [commands, matrix, start] = parse(:part2, input)
    [_end, result] = execute(commands, matrix, start)
    sum_gps(result, @lbox)
  end

  @doc "Read input file"
  def input(),
    do:
      Aoc.input_lines(__MODULE__)
      |> Enum.to_list()

  @doc "Parse input for creating list of commands and matrix (i.e. map)"
  def parse(:part1, {commands, matrix}) do
    [
      Enum.reverse(commands) |> Enum.join(),
      Enum.reduce(matrix |> Enum.reverse() |> Enum.with_index(), [%{}, nil], fn {row, y}, acc ->
        Enum.reduce(String.graphemes(row) |> Enum.with_index(), acc, fn {symbol, x},
                                                                        [matrix, start] ->
          if symbol == @robot do
            [Map.update(matrix, {x, y}, symbol, fn _ -> symbol end), {x, y}]
          else
            [Map.update(matrix, {x, y}, symbol, fn _ -> symbol end), start]
          end
        end)
      end)
    ]
    |> List.flatten()
  end

  def parse(:part2, {commands, matrix}) do
    [
      Enum.reverse(commands) |> Enum.join(),
      Enum.reduce(matrix |> Enum.reverse() |> Enum.with_index(), [%{}, nil], fn {row, y}, acc ->
        Enum.reduce(String.graphemes(row) |> Enum.with_index(), acc, fn {symbol, x},
                                                                        [matrix, start] ->
          case symbol do
            @wall ->
              [
                Map.put(matrix, {2 * x, y}, symbol)
                |> Map.put({2 * x + 1, y}, @wall),
                start
              ]

            @robot ->
              [
                Map.put(matrix, {2 * x, y}, symbol)
                |> Map.put({2 * x + 1, y}, @empty),
                {2 * x, y}
              ]

            @box ->
              [
                Map.put(matrix, {2 * x, y}, "[")
                |> Map.put({2 * x + 1, y}, "]"),
                start
              ]

            @empty ->
              [
                Map.put(matrix, {2 * x, y}, symbol)
                |> Map.put({2 * x + 1, y}, @empty),
                start
              ]
          end
        end)
      end)
    ]
    |> List.flatten()
  end

  @doc "Execute list of commands"
  def execute(commands, matrix, start) when is_binary(commands) do
    Enum.reduce(Regex.split(~r//, commands), [start, matrix], fn command, [start, matrix] ->
      case command do
        "^" -> execute(@up, matrix, start)
        ">" -> execute(@right, matrix, start)
        "v" -> execute(@down, matrix, start)
        "<" -> execute(@left, matrix, start)
        _ -> [start, matrix]
      end
    end)
  end

  def execute(dir, matrix, start) when is_tuple(dir) do
    if changed = shift_box(matrix, start, dir) do
      [next(start, dir), changed]
    else
      [start, matrix]
    end
  end

  @doc """
  In order:
  * Both part 1 (robot and box) and 2 (robot): shift box with a single position (tuple) as start
  * Both part 1 and 2: shift box with no matrix
  * Part 2: shift box with two positions (tuples) as start
  """
  def shift_box(matrix, start, dir) when is_tuple(start) do
    finish = next(start, dir)

    case Map.get(matrix, finish) do
      @empty -> matrix
      @wall -> nil
      @box -> shift_box(matrix, finish, dir)
      @lbox when dir in [@left, @right] -> shift_box(matrix, finish, dir)
      @rbox when dir in [@left, @right] -> shift_box(matrix, finish, dir)
      @lbox -> shift_box(matrix, [finish, next(finish, @right)], dir)
      @rbox -> shift_box(matrix, [next(finish, @left), finish], dir)
    end
    |> switch_positions(start, finish)
  end

  def shift_box(nil, _, _), do: nil

  def shift_box(matrix, [l_start, r_start], dir) do
    l_next = next(l_start, dir)
    r_next = next(r_start, dir)

    case Enum.join(Enum.map([l_next, r_next], &Map.get(matrix, &1))) do
      ".." ->
        matrix

      "[]" ->
        shift_box(matrix, [l_next, r_next], dir)

      ".[" ->
        shift_box(matrix, [r_next, next(r_next, @right)], dir)

      "]." ->
        shift_box(matrix, [next(l_next, @left), l_next], dir)

      "][" ->
        shift_box(matrix, [next(l_next, @left), l_next], dir)
        |> shift_box([r_next, next(r_next, @right)], dir)

      _ ->
        nil
    end
    |> switch_positions(l_start, l_next)
    |> switch_positions(r_start, r_next)
  end

  @doc "Switch 2 positions in matrix"
  def switch_positions(nil, _, _), do: nil

  def switch_positions(matrix, from, to) do
    start = Map.get(matrix, from)

    Map.put(matrix, from, Map.get(matrix, to))
    |> Map.put(to, start)
  end

  @doc "Up position in appropriate direction"
  def next({from_x, from_y}, {dir_x, dir_y}), do: {from_x + dir_x, from_y + dir_y}

  def sum_gps(matrix, symbol) do
    Enum.reduce(Map.keys(matrix), 0, fn point, acc ->
      if Map.get(matrix, point) == symbol, do: acc + gps(point), else: acc
    end)
  end

  defp gps({x, y}), do: 100 * y + x

  @doc "For testing purposes: show matrix"
  def display(matrix) do
    keys = Map.keys(matrix) |> Enum.sort_by(&{elem(&1, 1), elem(&1, 0)})
    height = keys |> Enum.map(&elem(&1, 1)) |> Enum.max()

    Enum.reduce(0..height, [], fn y, _ ->
      Enum.filter(keys, fn {_, b} -> b == y end)
      |> Enum.map(&Map.get(matrix, &1))
      |> Enum.join("")
      |> IO.puts()
    end)
  end
end
