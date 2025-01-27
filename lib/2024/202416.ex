defmodule Aoc202416 do
  @moduledoc """
  Dijkstra shortest path.
  """
  defmodule Coord do
    defstruct x: nil, y: nil

    @spec new(integer(), integer()) :: Coord
    def new(x, y), do: %Coord{x: x, y: y}
  end

  defmodule Value do
    defstruct dist: :inf, facing: nil, symbol: nil

    @spec new(integer(), atom(), char()) :: Value
    def new(dist, facing, symbol), do: %Value{dist: dist, facing: facing, symbol: symbol}
  end

  @facings [:north, :east, :south, :west]

  @spec turns(atom(), Coord) :: map()
  def turns(nil, _node), do: %{}

  def turns(facing, node) do
    index = Enum.find_index(@facings, &(&1 == facing))

    Enum.reduce(-1..1, %{}, fn dir, acc ->
      idx = rem(index + dir, 4)
      Map.put(acc, next(node, Enum.at(@facings, idx)), Enum.at(@facings, idx))
    end)
  end

  @spec neighbours(map(), Coord, list(Coord)) :: list(tuple())
  def neighbours(grid, node, unvisited) do
    Map.get(grid, node).facing
    |> turns(node)
    |> Enum.filter(fn {coord, _value} -> Enum.member?(unvisited, coord) end)
  end

  @spec next(Coord, :atom) :: Coord
  def next(node, :north), do: Coord.new(node.x, node.y - 1)
  def next(node, :east), do: Coord.new(node.x + 1, node.y)
  def next(node, :south), do: Coord.new(node.x, node.y + 1)
  def next(node, :west), do: Coord.new(node.x - 1, node.y)

  @spec symbol(atom()) :: char()
  def symbol(:north), do: "^"
  def symbol(:east), do: ">"
  def symbol(:south), do: "v"
  def symbol(:west), do: "<"

  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def timer(:part1), do: :timer.tc(__MODULE__, :part1, [])
  def timer(:part2), do: :timer.tc(__MODULE__, :part2, [])

  def part1() do
    input() |> parse()
  end

  def part2() do
  end

  @doc "Read input file"
  def input(),
    do:
      Aoc.input_lines(__MODULE__)
      |> Enum.map(&String.split(&1, "", trim: true))

  @doc "Convert input to map"
  def parse(matrix) do
    matrix
    |> Enum.with_index()
    |> Enum.reduce({%{}, nil, nil}, fn {row, y}, acc ->
      Enum.reduce(Enum.with_index(row), acc, fn {symbol, x}, {matrix, start, finish} ->
        case symbol do
          "S" ->
            {Map.put(matrix, Coord.new(x, y), Value.new(0, :east, symbol)), Coord.new(x, y),
             finish}

          "E" ->
            {Map.put(matrix, Coord.new(x, y), Value.new(:inf, nil, symbol)), start,
             Coord.new(x, y)}

          _ ->
            {Map.put(matrix, Coord.new(x, y), Value.new(:inf, nil, symbol)), start, finish}
        end
      end)
    end)
  end

  def shortest_path(matrix) do
    unvisited = Map.keys(matrix) |> Enum.filter(&(Map.get(matrix, &1).symbol != "#"))
    shortest_path(matrix, unvisited)
  end

  def shortest_path(matrix, []), do: matrix

  def shortest_path(matrix, unvisited) do
    # Find minimum dist in unvisited
    cursor = Enum.min_by(unvisited, &Map.get(matrix, &1).dist)
    start = Map.get(matrix, cursor)

    Enum.reduce(neighbours(matrix, cursor, unvisited), matrix, fn {coord, dir}, acc ->
      dist = if start.facing == dir, do: 1, else: 1000

      if Map.get(acc, coord).dist > start.dist + dist do
        case start.facing == dir do
          true ->
            # Continue in same direction
            Map.put(acc, coord, Value.new(start.dist + 1, start.facing, symbol(start.facing)))

          false ->
            # Turn the cursor and continue in new direction
            Map.put(acc, cursor, Value.new(start.dist, dir, symbol(dir)))
            |> Map.put(coord, Value.new(start.dist + 1001, dir, symbol(dir)))
        end
      else
        acc
      end
    end)
    # |> tap(&display(&1))
    |> shortest_path(unvisited -- [cursor])
  end

  @doc "For testing purposes: show matrix"
  def display(matrix) do
    keys = Map.keys(matrix) |> Enum.sort_by(&{&1.y, &1.x})
    height = keys |> Enum.map(& &1.y) |> Enum.max()

    Enum.reduce(0..height, [], fn y, _ ->
      Enum.filter(keys, fn coord -> coord.y == y end)
      |> Enum.map(&Map.get(matrix, &1).symbol)
      |> Enum.join("")
      |> IO.puts()
    end)
  end
end
