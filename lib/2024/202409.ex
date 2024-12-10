defmodule Aoc202409 do
  def run() do
    IO.inspect(part1())
    IO.inspect(part2())
  end

  def timer(:part1), do: :timer.tc(__MODULE__, :part1, [])
  def timer(:part2), do: :timer.tc(__MODULE__, :part2, [])

  def part1() do
    #disk_map = example()
    disk_map = disk_map()
    {acc, replacements} = {accumulator(disk_map), replacements(disk_map)}

    move(acc, replacements) |> IO.inspect
    |> checksum()
  end

  def part2() do
#    disk_map = example()
    disk_map = disk_map()
    {acc, replacements} = {accumulator(disk_map), replacements(disk_map) |> chunked()}

    move(:part2, acc, replacements)
    |> Enum.map(fn {file, size} -> file ++ List.duplicate(0, size) end)
    |> List.flatten() |> IO.inspect
    |> checksum()
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

  def move([{list, free} | tail], replacements) do
    cond do
      hd(replacements) in list ->
        Enum.take_while(replacements, &(&1 in list))

      free > 0 ->
        list ++
          Enum.take(replacements, free) ++ move(tail, Enum.drop(replacements, free))

      true ->
        list ++ move(tail, replacements)
    end
  end

  def checksum(list) do
    Enum.with_index(list)
    |> Enum.map(fn {value, index} -> value * index end)
    |> Enum.sum()
  end

  ########## Part 2 ##########
  def chunked([]), do: []

  def chunked(list) do
    {h, t} = Enum.split_with(list, &(&1 == hd(list)))
    [h] ++ chunked(t)
  end

  def remove(list, elts) do
    case Enum.find_index(list, fn {blocks, _free} -> Enum.all?(elts, &(&1 in blocks)) end) do
      nil ->
        list

      index ->
        {file, free} = Enum.at(list, index)
        {prev_file, prev_free} = Enum.at(list, index - 1)

        if length(elts) == length(file) do
          Enum.slice(list, 0..(index - 2)//1) ++
            [{prev_file, prev_free + length(elts) + free}] ++ Enum.slice(list, (index + 1)..-1//1)
        else
          Enum.slice(list, 0..(index - 2)//1) ++
            [{prev_file, prev_free + length(elts)}] ++
            [{file -- elts, free}] ++ Enum.slice(list, (index + 1)..-1//1)
        end
    end
  end

  def move(:part2, accumulator, replacements) do
    Enum.reduce(replacements, accumulator, fn file, acc ->
      case Enum.find_index(acc, fn {blocks, free} ->
             length(file) <= free and hd(blocks) < hd(file)
           end) do
        nil ->
          acc

        index when index > 0 ->
          {blocks, free} = Enum.at(acc, index)

          Enum.slice(acc, 0..(index - 1)//1) ++
            [{blocks ++ file, free - length(file)}] ++
            Enum.slice(remove(acc, file), (index + 1)..-1//1)

        index when index == 0 ->
          {blocks, free} = Enum.at(acc, index)

          [{blocks ++ file, free - length(file)}] ++
            Enum.slice(remove(acc, file), (index + 1)..-1//1)
      end
    end)
  end
end
