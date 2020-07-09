defmodule Dclixer.Request do
  @redirect "http://m.dcinside.com/api/redirect.php"
  @headers %{
    "User-Agent" => "dcinside.app",
    "Referer" => "http://www.dcinside.com",
    "Connection" => "Keep-Alive"
  }

  def get(url) do
    url
    |> HTTPoison.get()
    |> resolve_body()
  end

  def get_with_hash(url, query) do
    hash =
      "#{url}?#{query |> URI.encode_query()}"
      |> Base.encode64()

    @redirect
    |> HTTPoison.get(@headers, params: %{hash: hash}, follow_redirect: true)
    |> resolve_body()
  end

  def post_multipart(url, body) do
    url
    |> HTTPoison.post({:multipart, Map.to_list(body)}, @headers)
    |> resolve_body()
  end

  defp resolve_body({:ok, %HTTPoison.Response{body: body}}), do: body |> Poison.decode()
  defp resolve_body(error), do: error
end
