defmodule Dclixer.Article do
  @list "http://m.dcinside.com/api/gall_list_new.php"

  def list(gallery_id, app_id), do: list(gallery_id, app_id, "1", nil)

  def list(gallery_id, app_id, page, search) do
    query =
      %{
        id: gallery_id,
        app_id: app_id,
        page: page
      }
      |> append_search(search)

    @list
    |> Dclixer.Request.get_with_hash(query)
  end

  defp append_search(map, {type, keyword}),
    do: map |> Map.put("s_type", type) |> Map.put("serVal", keyword)

  defp append_search(map, nil), do: map
end
