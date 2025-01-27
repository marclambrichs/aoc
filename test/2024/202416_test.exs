defmodule Aoc202416_test do
  use ExUnit.Case

  import Aoc202416

  describe "example 1" do
    setup [:setup_example_1]

    test "returns cheapest path part 1", %{input: input} do
      {matrix, start, finish} = parse(input)
      grid = shortest_path(matrix)
      display(grid)
      assert 0 == Map.get(grid, start).dist
      assert 1004 == Map.get(grid, Aoc202416.Coord.new(1, 9)).dist
      assert 2006 == Map.get(grid, Aoc202416.Coord.new(3, 9)).dist
      assert 3008 == Map.get(grid, Aoc202416.Coord.new(3, 7)).dist
      assert 4016 == Map.get(grid, Aoc202416.Coord.new(11, 7)).dist
      assert 5022 == Map.get(grid, Aoc202416.Coord.new(11, 13)).dist

      assert 7036 == Map.get(grid, finish).dist
    end
  end

  describe "example 2" do
    setup [:setup_example_2]

    test "returns cheapest path part 1", %{input: input} do
      {matrix, _start, finish} = parse(input)
      grid = shortest_path(matrix)
      display(grid)
      assert 11048 == Map.get(grid, finish).dist
    end
  end

  describe "input file" do
    setup [:setup_input]

    test "returns cheapest path part 1", %{input: input} do
      {matrix, _start, finish} = parse(input)
      grid = shortest_path(matrix)
      display(grid)
      IO.inspect Map.get(grid, finish)
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
        ###############
        #.......#....E#
        #.#.###.#.###.#
        #.....#.#...#.#
        #.###.#####.#.#
        #.#.#.......#.#
        #.#.#####.###.#
        #...........#.#
        ###.#.#####.#.#
        #...#.....#.#.#
        #.#.#.###.#.#.#
        #.....#...#.#.#
        #.###.#.#.#.#.#
        #S..#.....#...#
        ###############
        """
        |> String.split("\n", trim: false)
        |> Enum.map(&String.split(&1, "", trim: true))

      2 ->
        """
        #################
        #...#...#...#..E#
        #.#.#.#.#.#.#.#.#
        #.#.#.#...#...#.#
        #.#.#.#.###.#.#.#
        #...#.#.#.....#.#
        #.#.#.#.#.#####.#
        #.#...#.#.#.....#
        #.#.#####.#.###.#
        #.#.#.......#...#
        #.#.###.#####.###
        #.#.#...#.....#.#
        #.#.#.#####.###.#
        #.#.#.........#.#
        #.#.#.#########.#
        #S#.............#
        #################
        """
        |> String.split("\n", trim: false)
        |> Enum.map(&String.split(&1, "", trim: true))
    end
  end
end
