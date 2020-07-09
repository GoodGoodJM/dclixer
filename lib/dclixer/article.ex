defmodule Dclixer.Article do
  alias Dclixer.{Request, Utils}

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
    |> Request.get_with_hash(query)
    |> Utils.take_first()
    |> Utils.resolve_key("gall_list")
  end

  defp append_search(map, {type, keyword}),
    do: map |> Map.put("s_type", type) |> Map.put("serVal", keyword)

  defp append_search(map, nil), do: map
end
