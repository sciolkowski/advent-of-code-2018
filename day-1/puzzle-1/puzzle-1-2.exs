defmodule Freq do
  @input_data_file_path "./inputdata"

  # Solve Puzzle 1
  def current, do: prepare_input |> Enum.sum

  # Solve Puzzle 2
  def seen_twice_first({:found, result}), do: IO.puts("Found! #{result}")
  def seen_twice_first(start_data \\ %{0 => 1, "current_value" => 0}) do
    prepare_input
    |> Enum.reduce(start_data, &maybe_second_time?(&1, &2))
    |> seen_twice_first
  end

  defp maybe_second_time?(elem, acc) do
    new_value = Map.get(acc, "current_value") + elem
    acc
    |> Map.has_key?(new_value)
    |> found_or_continue(acc, new_value)
  end

  defp found_or_continue(true, _acc, new_value), do: seen_twice_first({:found, Integer.to_string(new_value)})
  defp found_or_continue(false, acc, new_value) do
    acc
    |> Map.put("current_value", new_value)
    |> Map.put_new(new_value, 1)
  end

  defp prepare_input do
    File.stream!(@input_data_file_path)
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.to_list
  end
end
