defmodule Dclixer.Random do
  @alphabet Enum.concat([?0..?9, ?A..?Z, ?a..?z])

  def generate_random_string(count) do
    Stream.repeatedly(&get_random_character_from_alphabet/0)
    |> Enum.take(count)
    |> List.to_string()
  end

  defp get_random_character_from_alphabet() do
    Enum.random(@alphabet)
  end

  def generate_multipart_boundary() do
    :rand.uniform()
    |> Float.to_string()
    |> String.slice(2, 12)
  end
end
