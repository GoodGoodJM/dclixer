defmodule Dclixer do
  import Dclixer.Random

  def hello do
    :world
  end

  defmodule App do
    @signature "ReOo4u96nnv8Njd7707KpYiIVYQ3FlcKHDJE046Pg6s="
    @check "http://json2.dcinside.com/json0/app_check_A_rina.php"
    @key_verification "https://dcid.dcinside.com/join/mobile_app_key_verification_3rd.php"
    @headers %{
      "User-Agent" => "dcinside.app",
      "Referer" => "http://www.dcinside.com",
      "Connection" => "Keep-Alive"
    }

    def get_random_client_token,
      do: "#{generate_random_string(11)}:#{generate_random_string(139)}"

    def get_value_token,
      do: :crypto.hash(:sha256, "dcArdchk_#{get_date()}") |> Base.encode16(case: :lower)

    def get_date do
      @check
      |> HTTPoison.get()
      |> resolve_body()
      |> resolve_date()
    end

    def get_app_id, do: get_random_client_token() |> get_app_id()

    def get_app_id(client_token) do
      body = %{
        "client_token" => client_token,
        "value_token" => get_value_token(),
        "signature" => @signature
      }

      @key_verification
      |> HTTPoison.post({:multipart, Map.to_list(body)}, @headers)
      |> resolve_body()
      |> resolve_app_id()
    end

    defp resolve_date({:ok, body}), do: body |> Map.get("date")
    defp resolve_date(error), do: error

    defp resolve_app_id({:ok, body}), do: body |> Map.get("app_id")
    defp resolve_app_id(error), do: error

    defp resolve_body({:ok, %HTTPoison.Response{body: body}}),
      do: {:ok, body |> Poison.decode() |> resolve_body()}

    defp resolve_body({:ok, list}), do: list |> List.first()
    defp resolve_body(error), do: error
  end

  defmodule Article do
    @list "http://m.dcinside.com/api/gall_list_new.php"
    @redirect "http://m.dcinside.com/api/redirect.php"
    @headers %{
      "User-Agent" => "dcinside.app",
      "Referer" => "http://www.dcinside.com",
      "Connection" => "Keep-Alive"
    }

    def list(gallery_id, app_id), do: list(gallery_id, app_id, "1", nil)

    def list(gallery_id, app_id, page, search) do
      query =
        %{
          id: gallery_id,
          app_id: app_id,
          page: page
        }
        |> append_search(search)
        |> URI.encode_query()

      hash =
        "#{@list}?#{query}"
        |> Base.encode64()

      @redirect
      |> HTTPoison.get(@headers, params: %{hash: hash}, follow_redirect: true)
      |> resolve_body()
    end

    defp append_search(map, {type, keyword}),
      do: map |> Map.put("s_type", type) |> Map.put("serVal", keyword)

    defp append_search(map, nil), do: map

    defp resolve_body({:ok, %HTTPoison.Response{body: body}}),
      do: {:ok, body |> Poison.decode() |> resolve_body()}

    defp resolve_body(error), do: error
  end
end
