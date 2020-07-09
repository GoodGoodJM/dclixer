defmodule Dclixer.App do
  alias Dclixer.{Random, Request, Utils}

  @signature "ReOo4u96nnv8Njd7707KpYiIVYQ3FlcKHDJE046Pg6s="
  @check "http://json2.dcinside.com/json0/app_check_A_rina.php"
  @key_verification "https://dcid.dcinside.com/join/mobile_app_key_verification_3rd.php"

  def get_random_client_token,
    do: "#{Random.generate_random_string(11)}:#{Random.generate_random_string(139)}"

  def get_value_token,
    do: :crypto.hash(:sha256, "dcArdchk_#{get_date()}") |> Base.encode16(case: :lower)

  def get_date do
    @check
    |> Request.get()
    |> Utils.take_first()
    |> Utils.resolve_key("date")
  end

  def get_app_id, do: get_random_client_token() |> get_app_id()

  def get_app_id(client_token) do
    body = %{
      "client_token" => client_token,
      "value_token" => get_value_token(),
      "signature" => @signature
    }

    @key_verification
    |> Request.post_multipart(body)
    |> Utils.take_first()
    |> Utils.resolve_key("app_id")
  end
end
