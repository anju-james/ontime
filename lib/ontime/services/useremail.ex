defmodule Ontime.MessageService.UserEmail do
  import Swoosh.Email

  alias Ontime.Tracking

  def welcome(user) do
    new()
    |> to({user.name, user.email})
    |> from({"Ontime", "ontime@curiosumind.tech"})
    |> subject("Welcome Onboard!")
    |> html_body("<p>Hi #{user.name},</p>")
    |> html_body(
         "<p>Thanks for signing up with Ontime. From now you can stay back and relax
    while we track and update you on all your flight information. Travel stress free!</p>"
       )
    |> html_body(
         "<p>In the meantime, you can login and subscribe to regular alerts on your
    upcoming flights.</p>"
       )
    |> html_body("<p>Cheers,</p>")
    |> html_body("<p>Ontime Team</p>")
  end

  def subscribe(user, subscription) do
    flightnum = subscription.flight_data["carrierFsCode"] <> subscription.flight_data["flightNumber"]
    status = Tracking.map_flight_status(subscription.flight_data["status"])

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
    departure_gate_info = case subscription.flight_data do
      %{
        "airportResources" => %{
          "departureTerminal" => departureTerminal,
          "departureGate" => departureGate,
        }
      } -> "You will be departuring from Terminal: #{departureTerminal}, Gate: #{departureGate}"
      %{
        "airportResources" => %{
          "departureTerminal" => departureTerminal,
        }
      } -> "You will be departing from Terminal: #{departureTerminal}, Gate is still not assigned"
      _ -> "We are still waiting for departing terminal and gate information."
    end

    arrival_gate_info = case subscription.flight_data do
      %{
        "airportResources" => %{
          "arrivalTerminal" => arrivalTerminal,
          "arrivalGate" => arrivalGate
        }
      } -> "You will be arriving at Terminal: #{arrivalTerminal}, Gate: #{arrivalGate}"
      %{
        "airportResources" => %{
          "arrivalTerminal" => arrivalTerminal,
        }
      } -> "You will be arriving at Terminal: #{arrivalTerminal}, Gate is still not assigned"
      _ -> "We are still waiting for arrival terminal and gate information."
    end

    message = "<p>Hi #{user.name},</p>" <>
              "<p>We have started tracking your flight #{flightnum}
              from #{subscription.srcia_iata} to #{subscription.dest_iata}.</p>" <>
              "<p>The Departure time
              from #{subscription.srcia_iata} is #{departure_time}</p>" <>
              "<p>The Arrival time
              in #{subscription.dest_iata} is #{departure_time}</p>" <>
              "<p>#{departure_gate_info}</p>" <>
              "<p>#{arrival_gate_info}</p>" <>
              "<p>You will hearback from us again if anything
              changes with your flight.</p>" <>
              "<p>Cheers,</p>" <> "<p>Ontime Team</p>"

    new()
    |> to({user.name, user.email})
    |> from({"Ontime", "ontime@curiosumind.tech"})
    |> subject("New alert subscription for #{flightnum}.")
    |> html_body(message)


  end


  def notify(user, subscription) do
    flightnum = subscription.flight_data["carrierFsCode"] <> subscription.flight_data["flightNumber"]
    status = Tracking.map_flight_status(subscription.flight_data["status"])

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
    departure_gate_info = case subscription.flight_data do
      %{
        "airportResources" => %{
          "departureTerminal" => departureTerminal,
          "departureGate" => departureGate,
        }
      } -> "Departure Terminal: #{departureTerminal}, Departure Gate: #{departureGate}"
      %{
        "airportResources" => %{
          "departureTerminal" => departureTerminal,
        }
      } -> "Departure Terminal: #{departureTerminal}, Departure Gate: N/A"
      _ -> "We are still waiting for departing terminal and gate information."
    end

    arrival_gate_info = case subscription.flight_data do
      %{
        "airportResources" => %{
          "arrivalTerminal" => arrivalTerminal,
          "arrivalGate" => arrivalGate
        }
      } -> "Arriving Terminal: #{arrivalTerminal}, Arriving Gate: #{arrivalGate}"
      %{
        "airportResources" => %{
          "arrivalTerminal" => arrivalTerminal,
        }
      } -> "Arriving Terminal: #{arrivalTerminal}, Arriving Gate: N/A"
      _ -> "We are still waiting for arrival terminal and gate information."
    end

    message = "<p>Hi #{user.name},</p>" <>
              "<p>We have noticed some changes to your flight #{flightnum}
              from #{subscription.srcia_iata} to #{subscription.dest_iata}.</p>" <>
              "<p>The Departure time
              from #{subscription.srcia_iata} : #{departure_time}</p>" <>
              "<p>The Arrival time
              in #{subscription.dest_iata} : #{departure_time}</p>" <>
              "<p>#{departure_gate_info}</p>" <>
              "<p>#{arrival_gate_info}</p>" <>
              "<p>You will hearback from us again if anything
              changes with your flight.</p>" <>
              "<p>Cheers,</p>" <> "<p>Ontime Team</p>"

    new()
    |> to({user.name, user.email})
    |> from({"Ontime", "ontime@curiosumind.tech"})
    |> subject("Flight #{flightnum} changes alert.")
    |> html_body(message)


  end
end
