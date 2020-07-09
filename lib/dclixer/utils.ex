defmodule Dclixer.Utils do
  def take_first({:ok, list}), do: {:ok, list |> List.first()}
  def take_first(error), do: error

  def resolve_key({:ok, body}, key), do: body |> Map.get(key)
  def resolve_key(error, _), do: error
end
