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
    [commands, matrix, start] =
      example(0)
      |> parse()

    [_end, result] = execute(commands, matrix, start)

    Enum.reduce(Map.keys(result), 0, fn point, acc ->
      if Map.get(result, point) == @box, do: acc + gps(point), else: acc
    end)
  end

  def part2() do
    [commands, matrix, start] = parse(:part2, example(0))
    [_end, result] = execute(commands, matrix, start)

    matrix
    #    Enum.reduce(Map.keys(result), 0, fn point, acc ->
    #      if Map.get(result, point) == @lbox, do: acc + gps(point), else: acc
    #    end)
  end

  def example(nr \\ 0) do
    case nr do
      0 ->
        input()

      1 ->
        """
        ########
        #..O.O.#
        ##@.O..#
        #...O..#
        #.#.O..#
        #...O..#
        #......#
        ########

        <^^>>>vv
        <v>>v<<
        """
        |> String.split("\n", trim: false)
        |> List.delete_at(-1)

      2 ->
        """
        ##########
        #..O..O.O#
        #......O.#
        #.OO..O.O#
        #..O@..O.#
        #O#..O...#
        #O..O..O.#
        #.OO.O.OO#
        #....O...#
        ##########

        <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
        vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
        ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
        <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
        ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
        ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
        >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
        <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
        ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
        v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
        """
        |> String.split("\n", trim: false)
        |> List.delete_at(-1)

      3 ->
        """
        #######
        #...#.#
        #.....#
        #..OO@#
        #..O..#
        #.....#
        #######

        <vv<<^^<<^^
        """
        |> String.split("\n", trim: false)
        |> List.delete_at(-1)
    end
    |> Enum.reduce({[], []}, fn x, {xs, ys} ->
      if x == "", do: {ys, xs}, else: {[x | xs], ys}
    end)
  end

  def input(), do: Aoc.input_lines(__MODULE__) |> Enum.to_list()

  def parse({commands, matrix}) do
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
      [position(start, dir), changed]
    else
      [start, matrix]
    end
  end

  def shift_box(matrix, start, dir) when is_tuple(start) do
    finish = position(start, dir)

    case Map.get(matrix, finish) do
      @empty -> matrix
      @wall -> nil
      @box -> shift_box(matrix, finish, dir)
      @lbox when dir in [@left, @right] -> shift_box(matrix, finish, dir)
      @rbox when dir in [@left, @right] -> shift_box(matrix, finish, dir)
      @lbox -> shift_box(matrix, [finish, position(finish, @right)], dir)
      @rbox -> shift_box(matrix, [position(finish, @left), finish], dir)
    end
    |> switch_positions(start, finish)
  end

  def shift_box(nil, _, _), do: nil

  def shift_box(matrix, [l_start, r_start], dir) do
    l_finish = position(l_start, dir)
    r_finish = position(r_start, dir)

    case Enum.join(Enum.map([l_finish, r_finish], &Map.get(matrix, &1))) do
      ".." ->
        matrix

      "[]" ->
        shift_box(matrix, [l_finish, r_finish], dir)

      ".[" ->
        shift_box(matrix, [r_finish, position(r_finish, @right)], dir)

      "]." ->
        shift_box(matrix, [l_finish, position(l_finish, @left)], dir)

      "][" ->
        shift_box(matrix, [position(l_finish, @left), l_finish], dir)
        |> shift_box([r_finish, position(r_finish, @right)], dir)

      _ ->
        nil
    end
    |> switch_positions(l_start, l_finish)
    |> switch_positions(r_start, r_finish)
  end

  def switch_positions(nil, _, _), do: nil

  def switch_positions(matrix, from, to) do
    start = Map.get(matrix, from)

    Map.put(matrix, from, Map.get(matrix, to))
    |> Map.put(to, start)
  end

  def position({from_x, from_y}, {dir_x, dir_y}), do: {from_x + dir_x, from_y + dir_y}

  def gps({x, y}), do: 100 * y + x

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

  ########## Part 2 ##########
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
end
