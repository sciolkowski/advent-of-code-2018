defmodule Boxes do
  @input_data_file_path "./inputdata"
  @box_id_length 25
  @sample_data ["abcde", "fghij", "klmno", "pqrst", "fguij", "axcye", "wvxyz"]

  def find_common_pattern do
    data = prepare_input
    1..length(data)
    |> Enum.each(&search_matching(List.pop_at(data, &1)))
  end

  defp search_matching({:found, string}), do: raise "FOUND #{string}"
  defp search_matching({sample, []}), do: IO.puts("NOMATCH for #{sample}")
  defp search_matching({sample, [box_id | tail]}) do
    compare_ids(sample, box_id)
    search_matching({sample, tail})
  end

  defp compare_ids(id1, id2) do
    Enum.each(0..@box_id_length, fn (index) -> 
      splitted_id_1 = id1 |> String.codepoints
      splitted_id_2 = id2 |> String.codepoints
      compare_ids(splitted_id_1, splitted_id_2, index)
    end)
  end

  defp compare_ids(id1, id2, index) do
    {_ignore, rest1} = List.pop_at(id1, index)
    {_ignore, rest2} = List.pop_at(id2, index)
    maybe_found?(rest1 == rest2, rest1, rest2)
  end

  defp maybe_found?(true, string1, _string2), do: search_matching({:found, string1})
  defp maybe_found?(false, string1, _string2), do: IO.puts("#{string1}")

  defp prepare_input do
    File.stream!(@input_data_file_path)
    |> Enum.to_list
  end
end
