defmodule Ontime.MessageService.UserSMS do

  defp get_nexmo_api_key, do: Application.get_env(:ontime, :nexmo)[:NEXMO_API_KEY]

  defp get_nexmo_api_secret, do: Application.get_env(:ontime, :nexmo)[:NEXMO_API_SECRET]

  defp get_url, do: "https://rest.nexmo.com/sms/json"

  def send_sms(to, message) do
    with {:ok, %{international_code: country,area_code: areacode, number: number}} <- Phone.parse(to) do
      body = Poison.encode!(%{
        "api_key": get_nexmo_api_key(),
        "api_secret": get_nexmo_api_secret(),
        "to": country <> areacode <> number,
        "from": "12014739874",
        "text": "#{message}",

      })
      headers = [{"Content-type", "application/json"}]
      case HTTPoison.post(get_url(), body, headers, []) do
        {:ok, %HTTPoison.Response{status_code: 200, body: _}} -> true
        {:ok, %HTTPoison.Response{status_code: 404}} -> false
        {:error, %HTTPoison.Error{reason: _}} -> false
      end
    end
  end

end