defmodule Aoc202409 do
  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def part1() do
    # disk_map = example()
    disk_map = disk_map()
    {acc, replacements} = {accumulator(disk_map), replacements(disk_map)}

    move(acc, replacements)
    |> checksum()
  end

  def part2() do
  end

  def example(),
    do: "2333133121414131402" |> String.split("", trim: true) |> Enum.map(&String.to_integer/1)

  def disk_map() do
    Aoc.input_file(__MODULE__)
    |> File.stream!(1)
    |> Stream.reject(&(&1 == "\n"))
    |> Stream.map(&String.to_integer/1)
  end

  def replacements(disk_map) do
    Stream.take_every(disk_map, 2)
    |> Stream.with_index()
    |> Stream.map(fn {a, index} -> List.duplicate(index, a) end)
    |> Enum.reverse()
    |> List.flatten()
  end

  def accumulator(disk_map) do
    Stream.chunk_every(disk_map, 2)
    |> Stream.with_index()
    |> Stream.map(fn
      {[a, b], index} ->
        {List.duplicate(index, a), b}

      {[a], index} ->
        {List.duplicate(index, a), 0}
    end)
    |> Enum.to_list()
  end

  def move(accumulator, replacements) do
    [{list, free}] = Enum.take(accumulator, 1)

    cond do
      hd(replacements) in list ->
        Enum.take_while(replacements, &(&1 in list))

      free > 0 ->
        list ++
          Enum.take(replacements, free) ++ move(tl(accumulator), Enum.drop(replacements, free))

      true ->
        list ++ move(tl(accumulator), replacements)
    end
  end

  def checksum(list) do
    Enum.with_index(list)
    |> Enum.map(fn {value, index} -> value * index end)
    |> Enum.sum()
  end

  ########## Part 2 ##########
end
