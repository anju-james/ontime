defmodule Ontime.MessageService.UserSMS do
  alias Ontime.Tracking

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

  def subscribe_sms(user, subscription) do
    flightnum = subscription.flight_data["carrierFsCode"] <> subscription.flight_data["flightNumber"]
    status = Tracking.map_flight_status(subscription.flight_data["status"])
    message = "You are now subscribed to alerts for flight #{flightnum}."

    date_to_string = fn datestring ->
      datestring
      |> String.split(".")
      |> Enum.at(0)
      |> NaiveDateTime.from_iso8601!
      |> NaiveDateTime.to_string
    end
    arrival_time = subscription.flight_data["arrivalDate"]["dateLocal"]
                   |> date_to_string.()
    departure_time = subscription.flight_data["departureDate"]["dateLocal"]
                     |> date_to_string.()

    message = "#{message} The flight status now is #{status}. Flight will depart from #{subscription.srcia_iata}
    at #{departure_time} and arrive in #{subscription.dest_iata} at #{arrival_time}."
    send_sms(user.phonenumber, message)
  end

  def notify_sms(user, subscription) do
    flightnum = subscription.flight_data["carrierFsCode"] <> subscription.flight_data["flightNumber"]
    status = Tracking.map_flight_status(subscription.flight_data["status"])
    message = "We noticed some changes to your subscribed flight #{flightnum}."

    date_to_string = fn datestring ->
      datestring
      |> String.split(".")
      |> Enum.at(0)
      |> NaiveDateTime.from_iso8601!
      |> NaiveDateTime.to_string
    end
    arrival_time = subscription.flight_data["arrivalDate"]["dateLocal"]
                   |> date_to_string.()
    departure_time = subscription.flight_data["departureDate"]["dateLocal"]
                     |> date_to_string.()

    message = "#{message} The flight status is #{status}. Flight departure airport: #{subscription.srcia_iata}
    ,departure time: #{departure_time} and destination airport: #{subscription.dest_iata}, arrival time: #{arrival_time}."
    send_sms(user.phonenumber, message)
  end

end