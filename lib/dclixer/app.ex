defmodule Dclixer.App do
  import Dclixer.Random

  @signature "ReOo4u96nnv8Njd7707KpYiIVYQ3FlcKHDJE046Pg6s="
  @check "http://json2.dcinside.com/json0/app_check_A_rina.php"
  @key_verification "https://dcid.dcinside.com/join/mobile_app_key_verification_3rd.php"

  def get_random_client_token,
    do: "#{generate_random_string(11)}:#{generate_random_string(139)}"

  def get_value_token,
    do: :crypto.hash(:sha256, "dcArdchk_#{get_date()}") |> Base.encode16(case: :lower)

  defp take_first({:ok, list}), do: {:ok, list |> List.first()}
  defp take_first(error), do: error

  defp resolve_date({:ok, body}), do: body |> Map.get("date")
  defp resolve_date(error), do: error

  def get_date do
    @check
    |> Dclixer.Request.get()
    |> take_first()
    |> resolve_date()
  end

  defp resolve_app_id({:ok, body}), do: body |> Map.get("app_id")
  defp resolve_app_id(error), do: error

  def get_app_id, do: get_random_client_token() |> get_app_id()

  def get_app_id(client_token) do
    body = %{
      "client_token" => client_token,
      "value_token" => get_value_token(),
      "signature" => @signature
    }

    @key_verification
    |> Dclixer.Request.post_multipart(body)
    |> take_first()
    |> resolve_app_id()
  end
end
