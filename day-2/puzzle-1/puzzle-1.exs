defmodule Boxes do
  @input_data_file_path "./inputdata"
  @sample_data ["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"]

  def checksum do
    prepare_input
    |> Enum.reduce(%{double: 0, triple: 0}, &maybe_update_overall_count(&1, &2))
    |> Map.get(:total)
  end

  defp maybe_update_overall_count(box_id, %{double: _double, triple: _triple} = result) do
    box_id
    |> String.codepoints
    |> count_multiple_letters
    |> update_result(result)
  end

  defp count_multiple_letters(char_list, char_counter_map \\ %{})
  defp count_multiple_letters([], char_counter_map), do: char_counter_map |> Enum.reduce(%{double: 0, triple: 0}, &maybe_increase_multiple_counter?(&1, &2))
  defp count_multiple_letters([char | tail], char_counter_map) do
    update_char_counter_map = char_counter_map
    |> Map.has_key?(char)
    |> maybe_count_letter(char, char_counter_map)

    count_multiple_letters(tail, update_char_counter_map)
  end


  defp maybe_count_letter(false, char, char_counter_map), do: Map.put_new(char_counter_map, char, 1)
  defp maybe_count_letter(true, char, letter_counter) do
    {:ok, updated_char_counter_map } = letter_counter |> Map.get_and_update(char, &({:ok, &1 + 1}))
    updated_char_counter_map
  end

  defp maybe_increase_multiple_counter?({_elem, 2}, %{double: 0} = acc), do: Map.update!(acc, :double, &(&1 + 1))
  defp maybe_increase_multiple_counter?({_elem, 3}, %{triple: 0} = acc), do: Map.update!(acc, :triple, &(&1 + 1))
  defp maybe_increase_multiple_counter?(_other, acc), do: acc

  defp update_result(%{double: current_box_double, triple: current_box_triple}, %{double: overall_box_double, triple: overall_box_triple}) do
    %{
      double: overall_box_double + current_box_double,
      triple: overall_box_triple + current_box_triple,
      total: (overall_box_double + current_box_double) * (overall_box_triple + current_box_triple)
    }
  end

  defp prepare_input do
    File.stream!(@input_data_file_path)
    |> Enum.to_list
  end
end
