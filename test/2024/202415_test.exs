defmodule Aoc202415_test do
  use ExUnit.Case

  import Aoc202415

  describe "example 1" do
    setup [:setup_example_1]

    test "returns sum gps part 1", %{input: input} do
      [commands, matrix, start] = parse(:part1, input)
      [_end, result] = execute(commands, matrix, start)
      assert 2028 == sum_gps(result, "O")
    end
  end

  describe "example 2" do
    setup [:setup_example_2]

    test "returns sum gps part 1", %{input: input} do
      [commands, matrix, start] = parse(:part1, input)
      [_end, result] = execute(commands, matrix, start)
      assert 10092 == sum_gps(result, "O")
    end

    test "returns sum gps part 2", %{input: input} do
      [commands, matrix, start] = parse(:part2, input)
      [_end, result] = execute(commands, matrix, start)
      assert 9021 == sum_gps(result, "[")
    end
  end

  describe("day input file") do
    setup [:setup_input]

    test "returns sum gps part 1", %{input: input} do
      [commands, matrix, start] = parse(:part1, input)
      [_end, result] = execute(commands, matrix, start)
      assert 1559280 == sum_gps(result, "O")
    end

    test "returns sum gps part 2", %{input: input} do
      [commands, matrix, start] = parse(:part2, input)
      [_end, result] = execute(commands, matrix, start)
      assert 1576353 == sum_gps(result, "[")
    end

  end

  #
  # Named setups
  #
  defp setup_input(_context), do: %{input: example()}
  defp setup_example_1(_context), do: %{input: example(1)}
  defp setup_example_2(_context), do: %{input: example(2)}

  defp example(nr \\ 0) do
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
    end
    |> Enum.reduce({[], []}, fn x, {xs, ys} ->
      if x == "", do: {ys, xs}, else: {[x | xs], ys}
    end)
  end
end
