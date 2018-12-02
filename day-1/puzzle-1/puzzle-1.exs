defmodule Freq do
  def current(path \\ "./inputdata"), do: path |> prepare_input |> Enum.sum

  defp prepare_input(path) do
    File.stream!(path)
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.to_list
  end
end
