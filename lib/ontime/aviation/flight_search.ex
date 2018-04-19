defmodule Ontime.FlightSearch do

  @aviation_edge "aviationedge"
  @flight_stats "flightstats"


  def get_flightdata(src, dest, traveldate)do
    if true do
      get_test_data(@flight_stats)
    else
      get_live_data(@flight_stats, src, dest, traveldate)
    end
  end



  def get_flightdata(flight_id) do
    if true do
      get_test_flightdata(@flight_stats) |> Poison.decode!
    else
      get_live_flightdata(@flight_stats, flight_id)
    end
  end

  def get_live_flightdata(@flight_stats, flight_id) do
    url = "https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/#{flight_id}?appId=#{
      get_flightstat_app_id()
    }&appKey=#{get_flightstat_app_key()}"
    resp = HTTPoison.get!(url)
    Poison.decode!(resp.body)
  end


  defp get_live_data(@aviation_edge, src) do
    url = "http://aviation-edge.com/api/public/timetable?key=#{get_aviationedge_api_key}&iataCode=#{
      src
    }&type=departure"
    resp = HTTPoison.get!(url)
    Poison.decode!(resp.body)
  end

  def get_live_data(@flight_stats, src, dest, traveldate) do
    source = String.upcase(src)
    destination = String.upcase(dest)
    datefields = String.split(traveldate,"-")

    url = "https://api.flightstats.com/flex/flightstatus/rest/v2/json/route/status/#{source}/#{destination}/dep/#{Enum.at(datefields,0)}/#{Enum.at(datefields,1)}/#{Enum.at(datefields,2)}?appId=#{get_flightstat_app_id()}&appKey=#{get_flightstat_app_key}&hourOfDay=0&utc=false&codeType=IATA"

    resp = HTTPoison.get!(url)
    Poison.decode!(resp.body)
  end

  defp get_flight_status(@aviation_edge, flight_no) do
    url = "http://aviation-edge.com/api/public/flights?key=#{get_aviationedge_api_key}&flight[iataNumber]=#{flight_no}"
    resp = HTTPoison.get!(url)
    Poison.decode!(resp.body)
  end


  defp get_flightstat_app_id, do: Application.get_env(:ontime, :flightstats)[:app_id]

  defp get_flightstat_app_key, do: Application.get_env(:ontime, :flightstats)[:app_key]

  defp get_aviationedge_api_key, do: Application.get_env(:ontime, :aviationedge)[:api_key]

  defp get_test_flightdata(@flight_stats) do
    "{\"request\":{\"flightId\":{\"requested\":\"956571579\",\"interpreted\":956571579},\"extendedOptions\":{},\"url\":\"https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/956571579\"},\"appendix\":{\"airlines\":[{\"fs\":\"B6\",\"iata\":\"B6\",\"icao\":\"JBU\",\"name\":\"JetBlue Airways\",\"phoneNumber\":\"1-800-538-2583\",\"active\":true}],\"airports\":[{\"fs\":\"BOS\",\"iata\":\"BOS\",\"icao\":\"KBOS\",\"faa\":\"BOS\",\"name\":\"Logan International Airport\",\"street1\":\"One Harborside Drive\",\"street2\":\"\",\"city\":\"Boston\",\"cityCode\":\"BOS\",\"stateCode\":\"MA\",\"postalCode\":\"02128-2909\",\"countryCode\":\"US\",\"countryName\":\"United States\",\"regionName\":\"North America\",\"timeZoneRegionName\":\"America/New_York\",\"weatherZone\":\"MAZ015\",\"localTime\":\"2018-04-19T12:18:22.040\",\"utcOffsetHours\":-4,\"latitude\":42.36646,\"longitude\":-71.020176,\"elevationFeet\":19,\"classification\":1,\"active\":true,\"delayIndexUrl\":\"https://api.flightstats.com/flex/delayindex/rest/v1/json/airports/BOS?codeType=fs\",\"weatherUrl\":\"https://api.flightstats.com/flex/weather/rest/v1/json/all/BOS?codeType=fs\"},{\"fs\":\"JFK\",\"iata\":\"JFK\",\"icao\":\"KJFK\",\"faa\":\"JFK\",\"name\":\"John F. Kennedy International Airport\",\"street1\":\"JFK Airport\",\"city\":\"New York\",\"cityCode\":\"NYC\",\"stateCode\":\"NY\",\"postalCode\":\"11430\",\"countryCode\":\"US\",\"countryName\":\"United States\",\"regionName\":\"North America\",\"timeZoneRegionName\":\"America/New_York\",\"weatherZone\":\"NYZ178\",\"localTime\":\"2018-04-19T12:18:22.040\",\"utcOffsetHours\":-4,\"latitude\":40.642335,\"longitude\":-73.78817,\"elevationFeet\":13,\"classification\":1,\"active\":true,\"delayIndexUrl\":\"https://api.flightstats.com/flex/delayindex/rest/v1/json/airports/JFK?codeType=fs\",\"weatherUrl\":\"https://api.flightstats.com/flex/weather/rest/v1/json/all/JFK?codeType=fs\"}],\"equipments\":[{\"iata\":\"321\",\"name\":\"Airbus A321\",\"turboProp\":false,\"jet\":true,\"widebody\":false,\"regional\":false}]},\"flightStatus\":{\"flightId\":956571579,\"carrierFsCode\":\"B6\",\"flightNumber\":\"6101\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T18:40:00.000\",\"dateUtc\":\"2018-04-18T22:40:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T19:40:00.000\",\"dateUtc\":\"2018-04-18T23:40:00.000Z\"},\"status\":\"L\",\"operationalTimes\":{\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T18:40:00.000\",\"dateUtc\":\"2018-04-18T22:40:00.000Z\"},\"estimatedGateDeparture\":{\"dateLocal\":\"2018-04-18T19:06:00.000\",\"dateUtc\":\"2018-04-18T23:06:00.000Z\"},\"actualGateDeparture\":{\"dateLocal\":\"2018-04-18T19:06:00.000\",\"dateUtc\":\"2018-04-18T23:06:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T18:50:00.000\",\"dateUtc\":\"2018-04-18T22:50:00.000Z\"},\"estimatedRunwayDeparture\":{\"dateLocal\":\"2018-04-18T19:26:00.000\",\"dateUtc\":\"2018-04-18T23:26:00.000Z\"},\"actualRunwayDeparture\":{\"dateLocal\":\"2018-04-18T19:26:00.000\",\"dateUtc\":\"2018-04-18T23:26:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T19:40:00.000\",\"dateUtc\":\"2018-04-18T23:40:00.000Z\"},\"estimatedGateArrival\":{\"dateLocal\":\"2018-04-18T20:21:00.000\",\"dateUtc\":\"2018-04-19T00:21:00.000Z\"},\"actualGateArrival\":{\"dateLocal\":\"2018-04-18T20:21:00.000\",\"dateUtc\":\"2018-04-19T00:21:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T19:33:00.000\",\"dateUtc\":\"2018-04-18T23:33:00.000Z\"},\"estimatedRunwayArrival\":{\"dateLocal\":\"2018-04-18T20:18:00.000\",\"dateUtc\":\"2018-04-19T00:18:00.000Z\"},\"actualRunwayArrival\":{\"dateLocal\":\"2018-04-18T20:18:00.000\",\"dateUtc\":\"2018-04-19T00:18:00.000Z\"}},\"delays\":{\"departureGateDelayMinutes\":26,\"departureRunwayDelayMinutes\":36,\"arrivalGateDelayMinutes\":41,\"arrivalRunwayDelayMinutes\":45},\"flightDurations\":{\"scheduledBlockMinutes\":60,\"blockMinutes\":75,\"scheduledAirMinutes\":43,\"airMinutes\":52,\"scheduledTaxiOutMinutes\":10,\"taxiOutMinutes\":20,\"scheduledTaxiInMinutes\":7,\"taxiInMinutes\":3},\"airportResources\":{\"departureTerminal\":\"C\",\"departureGate\":\"C32\",\"arrivalTerminal\":\"5\",\"arrivalGate\":\"7\"},\"flightEquipment\":{\"actualEquipmentIataCode\":\"321\",\"tailNumber\":\"N569JB\"}}}
"
  end

  def get_test_data(@aviation_edge) do
    [
      %{
        "airline" => %{
          "iataCode" => "9W",
          "icaoCode" => "JAI",
          "name" => "Jet Airways (India)"
        },
        "arrival" => %{
          "baggage" => "E2",
          "gate" => "C65",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T18:30:00.000",
          "terminal" => "2"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "DL",
            "icaoCode" => "DAL",
            "name" => "Delta Air Lines"
          },
          "flight" => %{
            "iataNumber" => "DL1707",
            "icaoNumber" => "DAL1707",
            "number" => "1707"
          }
        },
        "departure" => %{
          "gate" => "A10",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T17:05:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "9W8378",
          "icaoNumber" => "JAI8378",
          "number" => "8378"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "AZ",
          "icaoCode" => "AZA",
          "name" => "Alitalia"
        },
        "arrival" => %{
          "baggage" => "E2",
          "gate" => "C65",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T18:30:00.000",
          "terminal" => "2"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "DL",
            "icaoCode" => "DAL",
            "name" => "Delta Air Lines"
          },
          "flight" => %{
            "iataNumber" => "DL1707",
            "icaoNumber" => "DAL1707",
            "number" => "1707"
          }
        },
        "departure" => %{
          "gate" => "A10",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T17:05:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "AZ5916",
          "icaoNumber" => "AZA5916",
          "number" => "5916"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "G3",
          "icaoCode" => "GLO",
          "name" => "Gol"
        },
        "arrival" => %{
          "baggage" => "E2",
          "gate" => "C65",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T18:30:00.000",
          "terminal" => "2"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "DL",
            "icaoCode" => "DAL",
            "name" => "Delta Air Lines"
          },
          "flight" => %{
            "iataNumber" => "DL1707",
            "icaoNumber" => "DAL1707",
            "number" => "1707"
          }
        },
        "departure" => %{
          "gate" => "A10",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T17:05:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "G38091",
          "icaoNumber" => "GLO8091",
          "number" => "8091"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "KE",
          "icaoCode" => "KAL",
          "name" => "Korean Air"
        },
        "arrival" => %{
          "baggage" => "E2",
          "gate" => "C65",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T18:30:00.000",
          "terminal" => "2"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "DL",
            "icaoCode" => "DAL",
            "name" => "Delta Air Lines"
          },
          "flight" => %{
            "iataNumber" => "DL1707",
            "icaoNumber" => "DAL1707",
            "number" => "1707"
          }
        },
        "departure" => %{
          "gate" => "A10",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T17:05:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "KE7308",
          "icaoNumber" => "KAL7308",
          "number" => "7308"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "KL",
          "icaoCode" => "KLM",
          "name" => "KLM"
        },
        "arrival" => %{
          "baggage" => "E2",
          "gate" => "C65",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T18:30:00.000",
          "terminal" => "2"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "DL",
            "icaoCode" => "DAL",
            "name" => "Delta Air Lines"
          },
          "flight" => %{
            "iataNumber" => "DL1707",
            "icaoNumber" => "DAL1707",
            "number" => "1707"
          }
        },
        "departure" => %{
          "gate" => "A10",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T17:05:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "KL5967",
          "icaoNumber" => "KLM5967",
          "number" => "5967"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "MU",
          "icaoCode" => "CES",
          "name" => "China Eastern Airlines"
        },
        "arrival" => %{
          "baggage" => "E2",
          "gate" => "C65",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T18:30:00.000",
          "terminal" => "2"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "DL",
            "icaoCode" => "DAL",
            "name" => "Delta Air Lines"
          },
          "flight" => %{
            "iataNumber" => "DL1707",
            "icaoNumber" => "DAL1707",
            "number" => "1707"
          }
        },
        "departure" => %{
          "gate" => "A10",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T17:05:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "MU8824",
          "icaoNumber" => "CES8824",
          "number" => "8824"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "UX",
          "icaoCode" => "AEA",
          "name" => "Air Europa"
        },
        "arrival" => %{
          "baggage" => "E2",
          "gate" => "C65",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T18:30:00.000",
          "terminal" => "2"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "DL",
            "icaoCode" => "DAL",
            "name" => "Delta Air Lines"
          },
          "flight" => %{
            "iataNumber" => "DL1707",
            "icaoNumber" => "DAL1707",
            "number" => "1707"
          }
        },
        "departure" => %{
          "gate" => "A10",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T17:05:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "UX3338",
          "icaoNumber" => "AEA3338",
          "number" => "3338"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "VS",
          "icaoCode" => "VIR",
          "name" => "Virgin Atlantic"
        },
        "arrival" => %{
          "baggage" => "E2",
          "gate" => "C65",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T18:30:00.000",
          "terminal" => "2"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "DL",
            "icaoCode" => "DAL",
            "name" => "Delta Air Lines"
          },
          "flight" => %{
            "iataNumber" => "DL1707",
            "icaoNumber" => "DAL1707",
            "number" => "1707"
          }
        },
        "departure" => %{
          "gate" => "A10",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T17:05:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "VS2715",
          "icaoNumber" => "VIR2715",
          "number" => "2715"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "WS",
          "icaoCode" => "WJA",
          "name" => "WestJet"
        },
        "arrival" => %{
          "baggage" => "E2",
          "gate" => "C65",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T18:30:00.000",
          "terminal" => "2"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "DL",
            "icaoCode" => "DAL",
            "name" => "Delta Air Lines"
          },
          "flight" => %{
            "iataNumber" => "DL1707",
            "icaoNumber" => "DAL1707",
            "number" => "1707"
          }
        },
        "departure" => %{
          "gate" => "A10",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T17:05:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "WS6829",
          "icaoNumber" => "WJA6829",
          "number" => "6829"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "DL",
          "icaoCode" => "DAL",
          "name" => "Delta Air Lines"
        },
        "arrival" => %{
          "baggage" => "E2",
          "gate" => "C65",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T18:30:00.000",
          "terminal" => "2"
        },
        "departure" => %{
          "gate" => "A10",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T17:05:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "DL1707",
          "icaoNumber" => "DAL1707",
          "number" => "1707"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "BA",
          "icaoCode" => "BAW",
          "name" => "British Airways"
        },
        "arrival" => %{
          "baggage" => "9",
          "estimatedTime" => "2018-04-16T19:23:00.000",
          "gate" => "32H",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T19:23:00.000",
          "terminal" => "8"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "AX",
            "icaoCode" => "LOF",
            "name" => "Trans States Airlines"
          },
          "flight" => %{
            "iataNumber" => "AX4384",
            "icaoNumber" => "LOF4384",
            "number" => "4384"
          }
        },
        "departure" => %{
          "estimatedTime" => "2018-04-16T17:55:00.000",
          "gate" => "B36",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T17:55:00.000",
          "terminal" => "B"
        },
        "flight" => %{
          "iataNumber" => "BA4905",
          "icaoNumber" => "BAW4905",
          "number" => "4905"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "CX",
          "icaoCode" => "CPA",
          "name" => "Cathay Pacific"
        },
        "arrival" => %{
          "baggage" => "9",
          "estimatedTime" => "2018-04-16T19:23:00.000",
          "gate" => "32H",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T19:23:00.000",
          "terminal" => "8"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "AX",
            "icaoCode" => "LOF",
            "name" => "Trans States Airlines"
          },
          "flight" => %{
            "iataNumber" => "AX4384",
            "icaoNumber" => "LOF4384",
            "number" => "4384"
          }
        },
        "departure" => %{
          "estimatedTime" => "2018-04-16T17:55:00.000",
          "gate" => "B36",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T17:55:00.000",
          "terminal" => "B"
        },
        "flight" => %{
          "iataNumber" => "CX7602",
          "icaoNumber" => "CPA7602",
          "number" => "7602"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "LA",
          "icaoCode" => "LAN",
          "name" => "LATAM Airlines"
        },
        "arrival" => %{
          "baggage" => "9",
          "estimatedTime" => "2018-04-16T19:23:00.000",
          "gate" => "32H",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T19:23:00.000",
          "terminal" => "8"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "AX",
            "icaoCode" => "LOF",
            "name" => "Trans States Airlines"
          },
          "flight" => %{
            "iataNumber" => "AX4384",
            "icaoNumber" => "LOF4384",
            "number" => "4384"
          }
        },
        "departure" => %{
          "estimatedTime" => "2018-04-16T17:55:00.000",
          "gate" => "B36",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T17:55:00.000",
          "terminal" => "B"
        },
        "flight" => %{
          "iataNumber" => "LA6490",
          "icaoNumber" => "LAN6490",
          "number" => "6490"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "MH",
          "icaoCode" => "MAS",
          "name" => "Malaysia Airlines"
        },
        "arrival" => %{
          "baggage" => "9",
          "estimatedTime" => "2018-04-16T19:23:00.000",
          "gate" => "32H",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T19:23:00.000",
          "terminal" => "8"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "AX",
            "icaoCode" => "LOF",
            "name" => "Trans States Airlines"
          },
          "flight" => %{
            "iataNumber" => "AX4384",
            "icaoNumber" => "LOF4384",
            "number" => "4384"
          }
        },
        "departure" => %{
          "estimatedTime" => "2018-04-16T17:55:00.000",
          "gate" => "B36",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T17:55:00.000",
          "terminal" => "B"
        },
        "flight" => %{
          "iataNumber" => "MH9543",
          "icaoNumber" => "MAS9543",
          "number" => "9543"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "QF",
          "icaoCode" => "QFA",
          "name" => "Qantas"
        },
        "arrival" => %{
          "baggage" => "9",
          "estimatedTime" => "2018-04-16T19:23:00.000",
          "gate" => "32H",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T19:23:00.000",
          "terminal" => "8"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "AX",
            "icaoCode" => "LOF",
            "name" => "Trans States Airlines"
          },
          "flight" => %{
            "iataNumber" => "AX4384",
            "icaoNumber" => "LOF4384",
            "number" => "4384"
          }
        },
        "departure" => %{
          "estimatedTime" => "2018-04-16T17:55:00.000",
          "gate" => "B36",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T17:55:00.000",
          "terminal" => "B"
        },
        "flight" => %{
          "iataNumber" => "QF4363",
          "icaoNumber" => "QFA4363",
          "number" => "4363"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "XL",
          "icaoCode" => "LNE",
          "name" => "LATAM Airlines Ecuador"
        },
        "arrival" => %{
          "baggage" => "9",
          "estimatedTime" => "2018-04-16T19:23:00.000",
          "gate" => "32H",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T19:23:00.000",
          "terminal" => "8"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "AX",
            "icaoCode" => "LOF",
            "name" => "Trans States Airlines"
          },
          "flight" => %{
            "iataNumber" => "AX4384",
            "icaoNumber" => "LOF4384",
            "number" => "4384"
          }
        },
        "departure" => %{
          "estimatedTime" => "2018-04-16T17:55:00.000",
          "gate" => "B36",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T17:55:00.000",
          "terminal" => "B"
        },
        "flight" => %{
          "iataNumber" => "XL6300",
          "icaoNumber" => "LNE6300",
          "number" => "6300"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "AA",
          "icaoCode" => "AAL",
          "name" => "American Airlines"
        },
        "arrival" => %{
          "baggage" => "9",
          "estimatedTime" => "2018-04-16T19:23:00.000",
          "gate" => "32H",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T19:23:00.000",
          "terminal" => "8"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "AX",
            "icaoCode" => "LOF",
            "name" => "Trans States Airlines"
          },
          "flight" => %{
            "iataNumber" => "AX4384",
            "icaoNumber" => "LOF4384",
            "number" => "4384"
          }
        },
        "departure" => %{
          "estimatedTime" => "2018-04-16T17:55:00.000",
          "gate" => "B36",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T17:55:00.000",
          "terminal" => "B"
        },
        "flight" => %{
          "iataNumber" => "AA4384",
          "icaoNumber" => "AAL4384",
          "number" => "4384"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "AX",
          "icaoCode" => "LOF",
          "name" => "Trans States Airlines"
        },
        "arrival" => %{
          "baggage" => "9",
          "estimatedTime" => "2018-04-16T19:23:00.000",
          "gate" => "32H",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T19:23:00.000",
          "terminal" => "8"
        },
        "departure" => %{
          "estimatedTime" => "2018-04-16T17:55:00.000",
          "gate" => "B36",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T17:55:00.000",
          "terminal" => "B"
        },
        "flight" => %{
          "iataNumber" => "AX4384",
          "icaoNumber" => "LOF4384",
          "number" => "4384"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "EI",
          "icaoCode" => "EIN",
          "name" => "Aer Lingus"
        },
        "arrival" => %{
          "estimatedTime" => "2018-04-16T20:02:00.000",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T20:02:00.000",
          "terminal" => "5"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "B6",
            "icaoCode" => "JBU",
            "name" => "JetBlue Airways"
          },
          "flight" => %{
            "iataNumber" => "B62717",
            "icaoNumber" => "JBU2717",
            "number" => "2717"
          }
        },
        "departure" => %{
          "estimatedTime" => "2018-04-16T18:30:00.000",
          "gate" => "C30",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T18:30:00.000",
          "terminal" => "C"
        },
        "flight" => %{
          "iataNumber" => "EI5021",
          "icaoNumber" => "EIN5021",
          "number" => "5021"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "EK",
          "icaoCode" => "UAE",
          "name" => "Emirates"
        },
        "arrival" => %{
          "estimatedTime" => "2018-04-16T20:02:00.000",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T20:02:00.000",
          "terminal" => "5"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "B6",
            "icaoCode" => "JBU",
            "name" => "JetBlue Airways"
          },
          "flight" => %{
            "iataNumber" => "B62717",
            "icaoNumber" => "JBU2717",
            "number" => "2717"
          }
        },
        "departure" => %{
          "estimatedTime" => "2018-04-16T18:30:00.000",
          "gate" => "C30",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T18:30:00.000",
          "terminal" => "C"
        },
        "flight" => %{
          "iataNumber" => "EK6704",
          "icaoNumber" => "UAE6704",
          "number" => "6704"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "EY",
          "icaoCode" => "ETD",
          "name" => "Etihad Airways"
        },
        "arrival" => %{
          "estimatedTime" => "2018-04-16T20:02:00.000",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T20:02:00.000",
          "terminal" => "5"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "B6",
            "icaoCode" => "JBU",
            "name" => "JetBlue Airways"
          },
          "flight" => %{
            "iataNumber" => "B62717",
            "icaoNumber" => "JBU2717",
            "number" => "2717"
          }
        },
        "departure" => %{
          "estimatedTime" => "2018-04-16T18:30:00.000",
          "gate" => "C30",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T18:30:00.000",
          "terminal" => "C"
        },
        "flight" => %{
          "iataNumber" => "EY8241",
          "icaoNumber" => "ETD8241",
          "number" => "8241"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "LY",
          "icaoCode" => "ELY",
          "name" => "El Al"
        },
        "arrival" => %{
          "estimatedTime" => "2018-04-16T20:02:00.000",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T20:02:00.000",
          "terminal" => "5"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "B6",
            "icaoCode" => "JBU",
            "name" => "JetBlue Airways"
          },
          "flight" => %{
            "iataNumber" => "B62717",
            "icaoNumber" => "JBU2717",
            "number" => "2717"
          }
        },
        "departure" => %{
          "estimatedTime" => "2018-04-16T18:30:00.000",
          "gate" => "C30",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T18:30:00.000",
          "terminal" => "C"
        },
        "flight" => %{
          "iataNumber" => "LY8606",
          "icaoNumber" => "ELY8606",
          "number" => "8606"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "QR",
          "icaoCode" => "QTR",
          "name" => "Qatar Airways"
        },
        "arrival" => %{
          "estimatedTime" => "2018-04-16T20:02:00.000",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T20:02:00.000",
          "terminal" => "5"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "B6",
            "icaoCode" => "JBU",
            "name" => "JetBlue Airways"
          },
          "flight" => %{
            "iataNumber" => "B62717",
            "icaoNumber" => "JBU2717",
            "number" => "2717"
          }
        },
        "departure" => %{
          "estimatedTime" => "2018-04-16T18:30:00.000",
          "gate" => "C30",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T18:30:00.000",
          "terminal" => "C"
        },
        "flight" => %{
          "iataNumber" => "QR3912",
          "icaoNumber" => "QTR3912",
          "number" => "3912"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "B6",
          "icaoCode" => "JBU",
          "name" => "JetBlue Airways"
        },
        "arrival" => %{
          "estimatedTime" => "2018-04-16T20:02:00.000",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T20:02:00.000",
          "terminal" => "5"
        },
        "departure" => %{
          "estimatedTime" => "2018-04-16T18:30:00.000",
          "gate" => "C30",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T18:30:00.000",
          "terminal" => "C"
        },
        "flight" => %{
          "iataNumber" => "B62717",
          "icaoNumber" => "JBU2717",
          "number" => "2717"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "AF",
          "icaoCode" => "AFR",
          "name" => "Air France"
        },
        "arrival" => %{
          "baggage" => "T4",
          "gate" => "B47",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T20:54:00.000",
          "terminal" => "4"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "9E",
            "icaoCode" => "EDV",
            "name" => "Endeavor Air"
          },
          "flight" => %{
            "iataNumber" => "9E3471",
            "icaoNumber" => "EDV3471",
            "number" => "3471"
          }
        },
        "departure" => %{
          "gate" => "A11",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T19:25:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "AF8512",
          "icaoNumber" => "AFR8512",
          "number" => "8512"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "AZ",
          "icaoCode" => "AZA",
          "name" => "Alitalia"
        },
        "arrival" => %{
          "baggage" => "T4",
          "gate" => "B47",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T20:54:00.000",
          "terminal" => "4"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "9E",
            "icaoCode" => "EDV",
            "name" => "Endeavor Air"
          },
          "flight" => %{
            "iataNumber" => "9E3471",
            "icaoNumber" => "EDV3471",
            "number" => "3471"
          }
        },
        "departure" => %{
          "gate" => "A11",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T19:25:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "AZ5917",
          "icaoNumber" => "AZA5917",
          "number" => "5917"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "KE",
          "icaoCode" => "KAL",
          "name" => "Korean Air"
        },
        "arrival" => %{
          "baggage" => "T4",
          "gate" => "B47",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T20:54:00.000",
          "terminal" => "4"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "9E",
            "icaoCode" => "EDV",
            "name" => "Endeavor Air"
          },
          "flight" => %{
            "iataNumber" => "9E3471",
            "icaoNumber" => "EDV3471",
            "number" => "3471"
          }
        },
        "departure" => %{
          "gate" => "A11",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T19:25:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "KE7310",
          "icaoNumber" => "KAL7310",
          "number" => "7310"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "KL",
          "icaoCode" => "KLM",
          "name" => "KLM"
        },
        "arrival" => %{
          "baggage" => "T4",
          "gate" => "B47",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T20:54:00.000",
          "terminal" => "4"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "9E",
            "icaoCode" => "EDV",
            "name" => "Endeavor Air"
          },
          "flight" => %{
            "iataNumber" => "9E3471",
            "icaoNumber" => "EDV3471",
            "number" => "3471"
          }
        },
        "departure" => %{
          "gate" => "A11",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T19:25:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "KL6475",
          "icaoNumber" => "KLM6475",
          "number" => "6475"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "MU",
          "icaoCode" => "CES",
          "name" => "China Eastern Airlines"
        },
        "arrival" => %{
          "baggage" => "T4",
          "gate" => "B47",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T20:54:00.000",
          "terminal" => "4"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "9E",
            "icaoCode" => "EDV",
            "name" => "Endeavor Air"
          },
          "flight" => %{
            "iataNumber" => "9E3471",
            "icaoNumber" => "EDV3471",
            "number" => "3471"
          }
        },
        "departure" => %{
          "gate" => "A11",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T19:25:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "MU8866",
          "icaoNumber" => "CES8866",
          "number" => "8866"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "UX",
          "icaoCode" => "AEA",
          "name" => "Air Europa"
        },
        "arrival" => %{
          "baggage" => "T4",
          "gate" => "B47",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T20:54:00.000",
          "terminal" => "4"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "9E",
            "icaoCode" => "EDV",
            "name" => "Endeavor Air"
          },
          "flight" => %{
            "iataNumber" => "9E3471",
            "icaoNumber" => "EDV3471",
            "number" => "3471"
          }
        },
        "departure" => %{
          "gate" => "A11",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T19:25:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "UX3315",
          "icaoNumber" => "AEA3315",
          "number" => "3315"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "VS",
          "icaoCode" => "VIR",
          "name" => "Virgin Atlantic"
        },
        "arrival" => %{
          "baggage" => "T4",
          "gate" => "B47",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T20:54:00.000",
          "terminal" => "4"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "9E",
            "icaoCode" => "EDV",
            "name" => "Endeavor Air"
          },
          "flight" => %{
            "iataNumber" => "9E3471",
            "icaoNumber" => "EDV3471",
            "number" => "3471"
          }
        },
        "departure" => %{
          "gate" => "A11",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T19:25:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "VS4654",
          "icaoNumber" => "VIR4654",
          "number" => "4654"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "WS",
          "icaoCode" => "WJA",
          "name" => "WestJet"
        },
        "arrival" => %{
          "baggage" => "T4",
          "gate" => "B47",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T20:54:00.000",
          "terminal" => "4"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "9E",
            "icaoCode" => "EDV",
            "name" => "Endeavor Air"
          },
          "flight" => %{
            "iataNumber" => "9E3471",
            "icaoNumber" => "EDV3471",
            "number" => "3471"
          }
        },
        "departure" => %{
          "gate" => "A11",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T19:25:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "WS6421",
          "icaoNumber" => "WJA6421",
          "number" => "6421"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "DL",
          "icaoCode" => "DAL",
          "name" => "Delta Air Lines"
        },
        "arrival" => %{
          "baggage" => "T4",
          "gate" => "B47",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T20:54:00.000",
          "terminal" => "4"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "9E",
            "icaoCode" => "EDV",
            "name" => "Endeavor Air"
          },
          "flight" => %{
            "iataNumber" => "9E3471",
            "icaoNumber" => "EDV3471",
            "number" => "3471"
          }
        },
        "departure" => %{
          "gate" => "A11",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T19:25:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "DL3471",
          "icaoNumber" => "DAL3471",
          "number" => "3471"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "9E",
          "icaoCode" => "EDV",
          "name" => "Endeavor Air"
        },
        "arrival" => %{
          "baggage" => "T4",
          "gate" => "B47",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T20:54:00.000",
          "terminal" => "4"
        },
        "departure" => %{
          "gate" => "A11",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T19:25:00.000",
          "terminal" => "A"
        },
        "flight" => %{
          "iataNumber" => "9E3471",
          "icaoNumber" => "EDV3471",
          "number" => "3471"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "EI",
          "icaoCode" => "EIN",
          "name" => "Aer Lingus"
        },
        "arrival" => %{
          "estimatedTime" => "2018-04-16T22:12:00.000",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T22:12:00.000",
          "terminal" => "5"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "B6",
            "icaoCode" => "JBU",
            "name" => "JetBlue Airways"
          },
          "flight" => %{
            "iataNumber" => "B6317",
            "icaoNumber" => "JBU317",
            "number" => "317"
          }
        },
        "departure" => %{
          "estimatedTime" => "2018-04-16T20:54:00.000",
          "gate" => "C29",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T20:54:00.000",
          "terminal" => "C"
        },
        "flight" => %{
          "iataNumber" => "EI5013",
          "icaoNumber" => "EIN5013",
          "number" => "5013"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "HA",
          "icaoCode" => "HAL",
          "name" => "Hawaiian Airlines"
        },
        "arrival" => %{
          "estimatedTime" => "2018-04-16T22:12:00.000",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T22:12:00.000",
          "terminal" => "5"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "B6",
            "icaoCode" => "JBU",
            "name" => "JetBlue Airways"
          },
          "flight" => %{
            "iataNumber" => "B6317",
            "icaoNumber" => "JBU317",
            "number" => "317"
          }
        },
        "departure" => %{
          "estimatedTime" => "2018-04-16T20:54:00.000",
          "gate" => "C29",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T20:54:00.000",
          "terminal" => "C"
        },
        "flight" => %{
          "iataNumber" => "HA2001",
          "icaoNumber" => "HAL2001",
          "number" => "2001"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "TP",
          "icaoCode" => "TAP",
          "name" => "TAP Portugal"
        },
        "arrival" => %{
          "estimatedTime" => "2018-04-16T22:12:00.000",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T22:12:00.000",
          "terminal" => "5"
        },
        "codeshared" => %{
          "airline" => %{
            "iataCode" => "B6",
            "icaoCode" => "JBU",
            "name" => "JetBlue Airways"
          },
          "flight" => %{
            "iataNumber" => "B6317",
            "icaoNumber" => "JBU317",
            "number" => "317"
          }
        },
        "departure" => %{
          "estimatedTime" => "2018-04-16T20:54:00.000",
          "gate" => "C29",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T20:54:00.000",
          "terminal" => "C"
        },
        "flight" => %{
          "iataNumber" => "TP8001",
          "icaoNumber" => "TAP8001",
          "number" => "8001"
        },
        "status" => "scheduled",
        "type" => "departure"
      },
      %{
        "airline" => %{
          "iataCode" => "B6",
          "icaoCode" => "JBU",
          "name" => "JetBlue Airways"
        },
        "arrival" => %{
          "estimatedTime" => "2018-04-16T22:12:00.000",
          "iataCode" => "JFK",
          "icaoCode" => "KJFK",
          "scheduledTime" => "2018-04-16T22:12:00.000",
          "terminal" => "5"
        },
        "departure" => %{
          "estimatedTime" => "2018-04-16T20:54:00.000",
          "gate" => "C29",
          "iataCode" => "BOS",
          "icaoCode" => "KBOS",
          "scheduledTime" => "2018-04-16T20:54:00.000",
          "terminal" => "C"
        },
        "flight" => %{
          "iataNumber" => "B6317",
          "icaoNumber" => "JBU317",
          "number" => "317"
        },
        "status" => "scheduled",
        "type" => "departure"
      }
    ]
  end

  def get_test_data(@flight_stats) do
    Poison.decode!(
      "{\"request\":{\"departureAirport\":{\"requestedCode\":\"BOS\",\"fsCode\":\"BOS\"},\"arrivalAirport\":{\"requestedCode\":\"JFK\",\"fsCode\":\"JFK\"},\"date\":{\"year\":\"2018\",\"month\":\"4\",\"day\":\"18\",\"interpreted\":\"2018-04-18\"},\"hourOfDay\":{\"requested\":\"0\",\"interpreted\":0},\"utc\":{\"requested\":\"false\",\"interpreted\":false},\"numHours\":{\"interpreted\":24},\"codeType\":{\"requested\":\"IATA\",\"interpreted\":\"IATA\"},\"maxFlights\":{},\"extendedOptions\":{},\"url\":\"https:\/\/api.flightstats.com\/flex\/flightstatus\/rest\/v2\/json\/route\/status\/BOS\/JFK\/dep\/2018\/4\/18\"},\"appendix\":{\"airlines\":[{\"fs\":\"JJ\",\"iata\":\"JJ\",\"icao\":\"TAM\",\"name\":\"LATAM Airlines Brasil\",\"phoneNumber\":\"1-888-2FLY TAM\",\"active\":true},{\"fs\":\"JL\",\"iata\":\"JL\",\"icao\":\"JAL\",\"name\":\"JAL\",\"phoneNumber\":\"0120-25-5931\",\"active\":true},{\"fs\":\"DL\",\"iata\":\"DL\",\"icao\":\"DAL\",\"name\":\"Delta Air Lines\",\"phoneNumber\":\"1-800-221-1212\",\"active\":true},{\"fs\":\"G3\",\"iata\":\"G3\",\"icao\":\"GLO\",\"name\":\"Gol\",\"phoneNumber\":\"+55 11 2125 3200\",\"active\":true},{\"fs\":\"LY\",\"iata\":\"LY\",\"icao\":\"ELY\",\"name\":\"El Al\",\"phoneNumber\":\"+ 972-3-9771111\",\"active\":true},{\"fs\":\"SA\",\"iata\":\"SA\",\"icao\":\"SAA\",\"name\":\"South African Airways\",\"phoneNumber\":\"+27 11 978 5313\",\"active\":true},{\"fs\":\"QF\",\"iata\":\"QF\",\"icao\":\"QFA\",\"name\":\"Qantas\",\"phoneNumber\":\"+61 2 9691 3636\",\"active\":true},{\"fs\":\"IB\",\"iata\":\"IB\",\"icao\":\"IBE\",\"name\":\"Iberia\",\"phoneNumber\":\"1800 772 4642\",\"active\":true},{\"fs\":\"KE\",\"iata\":\"KE\",\"icao\":\"KAL\",\"name\":\"Korean Air\",\"phoneNumber\":\"1-800-438-5000\",\"active\":true},{\"fs\":\"MH\",\"iata\":\"MH\",\"icao\":\"MAS\",\"name\":\"Malaysia Airlines\",\"phoneNumber\":\"+603 7843 3000\",\"active\":true},{\"fs\":\"WS\",\"iata\":\"WS\",\"icao\":\"WJA\",\"name\":\"WestJet\",\"phoneNumber\":\"1-888-937-8538\",\"active\":true},{\"fs\":\"OK\",\"iata\":\"OK\",\"icao\":\"CSA\",\"name\":\"CSA\",\"phoneNumber\":\"+1 (866) 293-8702\",\"active\":true},{\"fs\":\"SQ\",\"iata\":\"SQ\",\"icao\":\"SIA\",\"name\":\"Singapore Airlines\",\"phoneNumber\":\"+1 800 7423333\",\"active\":true},{\"fs\":\"AA\",\"iata\":\"AA\",\"icao\":\"AAL\",\"name\":\"American Airlines\",\"phoneNumber\":\"08457-567-567\",\"active\":true},{\"fs\":\"KL\",\"iata\":\"KL\",\"icao\":\"KLM\",\"name\":\"KLM\",\"phoneNumber\":\"1-800-447-4747\",\"active\":true},{\"fs\":\"QR\",\"iata\":\"QR\",\"icao\":\"QTR\",\"name\":\"Qatar Airways\",\"phoneNumber\":\"+1 877 777 2827\",\"active\":true},{\"fs\":\"UX\",\"iata\":\"UX\",\"icao\":\"AEA\",\"name\":\"Air Europa\",\"phoneNumber\":\"1.800.238.7672\",\"active\":true},{\"fs\":\"EI\",\"iata\":\"EI\",\"icao\":\"EIN\",\"name\":\"Aer Lingus\",\"phoneNumber\":\"1-800-IRISHAIR\",\"active\":true},{\"fs\":\"AF\",\"iata\":\"AF\",\"icao\":\"AFR\",\"name\":\"Air France\",\"phoneNumber\":\"1-800-237-2747\",\"active\":true},{\"fs\":\"EK\",\"iata\":\"EK\",\"icao\":\"UAE\",\"name\":\"Emirates\",\"phoneNumber\":\"800 777 3999\",\"active\":true},{\"fs\":\"MU\",\"iata\":\"MU\",\"icao\":\"CES\",\"name\":\"China Eastern Airlines\",\"phoneNumber\":\"+86 21 95108\",\"active\":true},{\"fs\":\"AM\",\"iata\":\"AM\",\"icao\":\"AMX\",\"name\":\"Aeromexico\",\"phoneNumber\":\"1-800-237-6639\",\"active\":true},{\"fs\":\"9E\",\"iata\":\"9E\",\"icao\":\"EDV\",\"name\":\"Endeavor Air\",\"active\":true},{\"fs\":\"AR\",\"iata\":\"AR\",\"icao\":\"ARG\",\"name\":\"Aerolineas Argentinas\",\"phoneNumber\":\"1-800-333-0276\",\"active\":true},{\"fs\":\"AT\",\"iata\":\"AT\",\"icao\":\"RAM\",\"name\":\"Royal Air Maroc\",\"active\":true},{\"fs\":\"B6\",\"iata\":\"B6\",\"icao\":\"JBU\",\"name\":\"JetBlue Airways\",\"phoneNumber\":\"1-800-538-2583\",\"active\":true},{\"fs\":\"EY\",\"iata\":\"EY\",\"icao\":\"ETD\",\"name\":\"Etihad Airways\",\"active\":true},{\"fs\":\"XL\",\"iata\":\"XL\",\"icao\":\"LNE\",\"name\":\"LATAM Airlines Ecuador\",\"active\":true},{\"fs\":\"CX\",\"iata\":\"CX\",\"icao\":\"CPA\",\"name\":\"Cathay Pacific\",\"phoneNumber\":\"1-800-233-2742\",\"active\":true},{\"fs\":\"LA\",\"iata\":\"LA\",\"icao\":\"LAN\",\"name\":\"LATAM Airlines\",\"phoneNumber\":\"1 (305) 670 9999\",\"active\":true},{\"fs\":\"CZ\",\"iata\":\"CZ\",\"icao\":\"CSN\",\"name\":\"China Southern Airlines\",\"phoneNumber\":\"+86 20 95539\",\"active\":true},{\"fs\":\"AX\",\"iata\":\"AX\",\"icao\":\"LOF\",\"name\":\"Trans States Airlines\",\"active\":true},{\"fs\":\"1I\",\"iata\":\"1I\",\"icao\":\"EJA\",\"name\":\"NetJets Aviation\",\"active\":true},{\"fs\":\"AY\",\"iata\":\"AY\",\"icao\":\"FIN\",\"name\":\"Finnair\",\"phoneNumber\":\"+ 358 600 140 140\",\"active\":true},{\"fs\":\"HA\",\"iata\":\"HA\",\"icao\":\"HAL\",\"name\":\"Hawaiian Airlines\",\"phoneNumber\":\"1-800-367-5320\",\"active\":true},{\"fs\":\"AZ\",\"iata\":\"AZ\",\"icao\":\"AZA\",\"name\":\"Alitalia\",\"phoneNumber\":\"1-800-223-5730\",\"active\":true},{\"fs\":\"TP\",\"iata\":\"TP\",\"icao\":\"TAP\",\"name\":\"TAP Portugal\",\"phoneNumber\":\"800 221-7370\",\"active\":true},{\"fs\":\"VS\",\"iata\":\"VS\",\"icao\":\"VIR\",\"name\":\"Virgin Atlantic\",\"active\":true},{\"fs\":\"9W\",\"iata\":\"9W\",\"icao\":\"JAI\",\"name\":\"Jet Airways (India)\",\"phoneNumber\":\"0808 101 1199 (UK toll free reservations)\",\"active\":true},{\"fs\":\"BA\",\"iata\":\"BA\",\"icao\":\"BAW\",\"name\":\"British Airways\",\"phoneNumber\":\"1-800-AIRWAYS\",\"active\":true}],\"airports\":[{\"fs\":\"BOS\",\"iata\":\"BOS\",\"icao\":\"KBOS\",\"faa\":\"BOS\",\"name\":\"Logan International Airport\",\"street1\":\"One Harborside Drive\",\"street2\":\"\",\"city\":\"Boston\",\"cityCode\":\"BOS\",\"stateCode\":\"MA\",\"postalCode\":\"02128-2909\",\"countryCode\":\"US\",\"countryName\":\"United States\",\"regionName\":\"North America\",\"timeZoneRegionName\":\"America\/New_York\",\"weatherZone\":\"MAZ015\",\"localTime\":\"2018-04-18T11:22:35.898\",\"utcOffsetHours\":-4,\"latitude\":42.36646,\"longitude\":-71.020176,\"elevationFeet\":19,\"classification\":1,\"active\":true,\"delayIndexUrl\":\"https:\/\/api.flightstats.com\/flex\/delayindex\/rest\/v1\/json\/airports\/BOS?codeType=fs\",\"weatherUrl\":\"https:\/\/api.flightstats.com\/flex\/weather\/rest\/v1\/json\/all\/BOS?codeType=fs\"},{\"fs\":\"JFK\",\"iata\":\"JFK\",\"icao\":\"KJFK\",\"faa\":\"JFK\",\"name\":\"John F. Kennedy International Airport\",\"street1\":\"JFK Airport\",\"city\":\"New York\",\"cityCode\":\"NYC\",\"stateCode\":\"NY\",\"postalCode\":\"11430\",\"countryCode\":\"US\",\"countryName\":\"United States\",\"regionName\":\"North America\",\"timeZoneRegionName\":\"America\/New_York\",\"weatherZone\":\"NYZ178\",\"localTime\":\"2018-04-18T11:22:35.898\",\"utcOffsetHours\":-4,\"latitude\":40.642335,\"longitude\":-73.78817,\"elevationFeet\":13,\"classification\":1,\"active\":true,\"delayIndexUrl\":\"https:\/\/api.flightstats.com\/flex\/delayindex\/rest\/v1\/json\/airports\/JFK?codeType=fs\",\"weatherUrl\":\"https:\/\/api.flightstats.com\/flex\/weather\/rest\/v1\/json\/all\/JFK?codeType=fs\"}],\"equipments\":[{\"iata\":\"32B\",\"name\":\"Airbus A321 (sharklets)\",\"turboProp\":false,\"jet\":true,\"widebody\":false,\"regional\":false},{\"iata\":\"ER4\",\"name\":\"Embraer RJ145\",\"turboProp\":false,\"jet\":true,\"widebody\":false,\"regional\":true},{\"iata\":\"CR9\",\"name\":\"Canadair (Bombardier) Regional Jet 900 and Challenger 890\",\"turboProp\":false,\"jet\":true,\"widebody\":false,\"regional\":true},{\"iata\":\"CCJ\",\"name\":\"Canadair (Bombardier) CL-600 \/ 601 \/ 604 \/ 605 Challenger\",\"turboProp\":false,\"jet\":true,\"widebody\":false,\"regional\":false},{\"iata\":\"73H\",\"name\":\"Boeing 737-800 (winglets) Passenger\/BBJ2\",\"turboProp\":false,\"jet\":true,\"widebody\":false,\"regional\":false},{\"iata\":\"321\",\"name\":\"Airbus A321\",\"turboProp\":false,\"jet\":true,\"widebody\":false,\"regional\":false},{\"iata\":\"32S\",\"name\":\"Airbus A318 \/ A319 \/ A320 \/ A321\",\"turboProp\":false,\"jet\":true,\"widebody\":false,\"regional\":false},{\"iata\":\"319\",\"name\":\"Airbus A319\",\"turboProp\":false,\"jet\":true,\"widebody\":false,\"regional\":false},{\"iata\":\"738\",\"name\":\"Boeing 737-800 Passenger\",\"turboProp\":false,\"jet\":true,\"widebody\":false,\"regional\":false},{\"iata\":\"E90\",\"name\":\"Embraer 190\",\"turboProp\":false,\"jet\":true,\"widebody\":false,\"regional\":true}]},\"flightStatuses\":[{\"flightId\":956261098,\"carrierFsCode\":\"B6\",\"flightNumber\":\"917\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T05:30:00.000\",\"dateUtc\":\"2018-04-18T09:30:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T06:43:00.000\",\"dateUtc\":\"2018-04-18T10:43:00.000Z\"},\"status\":\"L\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"RFJY\",\"restrictions\":\"\"},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T05:30:00.000\",\"dateUtc\":\"2018-04-18T09:30:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T06:43:00.000\",\"dateUtc\":\"2018-04-18T10:43:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T05:30:00.000\",\"dateUtc\":\"2018-04-18T09:30:00.000Z\"},\"estimatedGateDeparture\":{\"dateLocal\":\"2018-04-18T05:45:00.000\",\"dateUtc\":\"2018-04-18T09:45:00.000Z\"},\"actualGateDeparture\":{\"dateLocal\":\"2018-04-18T05:45:00.000\",\"dateUtc\":\"2018-04-18T09:45:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T05:42:00.000\",\"dateUtc\":\"2018-04-18T09:42:00.000Z\"},\"estimatedRunwayDeparture\":{\"dateLocal\":\"2018-04-18T05:59:00.000\",\"dateUtc\":\"2018-04-18T09:59:00.000Z\"},\"actualRunwayDeparture\":{\"dateLocal\":\"2018-04-18T05:59:00.000\",\"dateUtc\":\"2018-04-18T09:59:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T06:43:00.000\",\"dateUtc\":\"2018-04-18T10:43:00.000Z\"},\"estimatedGateArrival\":{\"dateLocal\":\"2018-04-18T06:49:00.000\",\"dateUtc\":\"2018-04-18T10:49:00.000Z\"},\"actualGateArrival\":{\"dateLocal\":\"2018-04-18T06:49:00.000\",\"dateUtc\":\"2018-04-18T10:49:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T06:25:00.000\",\"dateUtc\":\"2018-04-18T10:25:00.000Z\"},\"estimatedRunwayArrival\":{\"dateLocal\":\"2018-04-18T06:41:00.000\",\"dateUtc\":\"2018-04-18T10:41:00.000Z\"},\"actualRunwayArrival\":{\"dateLocal\":\"2018-04-18T06:41:00.000\",\"dateUtc\":\"2018-04-18T10:41:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"HA\",\"flightNumber\":\"2003\",\"relationship\":\"L\"},{\"fsCode\":\"SA\",\"flightNumber\":\"7353\",\"relationship\":\"L\"}],\"delays\":{\"departureGateDelayMinutes\":15,\"departureRunwayDelayMinutes\":17,\"arrivalGateDelayMinutes\":6,\"arrivalRunwayDelayMinutes\":16},\"flightDurations\":{\"scheduledBlockMinutes\":73,\"blockMinutes\":64,\"scheduledAirMinutes\":43,\"airMinutes\":42,\"scheduledTaxiOutMinutes\":12,\"taxiOutMinutes\":14,\"scheduledTaxiInMinutes\":18,\"taxiInMinutes\":8},\"airportResources\":{\"departureTerminal\":\"C\",\"departureGate\":\"C15\",\"arrivalTerminal\":\"5\",\"arrivalGate\":\"6\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"E90\",\"actualEquipmentIataCode\":\"E90\",\"tailNumber\":\"N373JB\"}},{\"flightId\":956271586,\"carrierFsCode\":\"DL\",\"flightNumber\":\"2471\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T06:00:00.000\",\"dateUtc\":\"2018-04-18T10:00:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T07:25:00.000\",\"dateUtc\":\"2018-04-18T11:25:00.000Z\"},\"status\":\"L\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"FY\",\"restrictions\":\"\"},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T06:00:00.000\",\"dateUtc\":\"2018-04-18T10:00:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T07:25:00.000\",\"dateUtc\":\"2018-04-18T11:25:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T06:00:00.000\",\"dateUtc\":\"2018-04-18T10:00:00.000Z\"},\"estimatedGateDeparture\":{\"dateLocal\":\"2018-04-18T05:59:00.000\",\"dateUtc\":\"2018-04-18T09:59:00.000Z\"},\"actualGateDeparture\":{\"dateLocal\":\"2018-04-18T05:59:00.000\",\"dateUtc\":\"2018-04-18T09:59:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T06:04:00.000\",\"dateUtc\":\"2018-04-18T10:04:00.000Z\"},\"estimatedRunwayDeparture\":{\"dateLocal\":\"2018-04-18T06:24:00.000\",\"dateUtc\":\"2018-04-18T10:24:00.000Z\"},\"actualRunwayDeparture\":{\"dateLocal\":\"2018-04-18T06:24:00.000\",\"dateUtc\":\"2018-04-18T10:24:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T07:25:00.000\",\"dateUtc\":\"2018-04-18T11:25:00.000Z\"},\"estimatedGateArrival\":{\"dateLocal\":\"2018-04-18T07:17:00.000\",\"dateUtc\":\"2018-04-18T11:17:00.000Z\"},\"actualGateArrival\":{\"dateLocal\":\"2018-04-18T07:17:00.000\",\"dateUtc\":\"2018-04-18T11:17:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T06:46:00.000\",\"dateUtc\":\"2018-04-18T10:46:00.000Z\"},\"estimatedRunwayArrival\":{\"dateLocal\":\"2018-04-18T07:09:00.000\",\"dateUtc\":\"2018-04-18T11:09:00.000Z\"},\"actualRunwayArrival\":{\"dateLocal\":\"2018-04-18T07:09:00.000\",\"dateUtc\":\"2018-04-18T11:09:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"AM\",\"flightNumber\":\"4556\",\"relationship\":\"L\"},{\"fsCode\":\"AR\",\"flightNumber\":\"7062\",\"relationship\":\"L\"},{\"fsCode\":\"AZ\",\"flightNumber\":\"5918\",\"relationship\":\"L\"},{\"fsCode\":\"VS\",\"flightNumber\":\"3094\",\"relationship\":\"L\"},{\"fsCode\":\"WS\",\"flightNumber\":\"6423\",\"relationship\":\"L\"}],\"delays\":{\"departureRunwayDelayMinutes\":20,\"arrivalRunwayDelayMinutes\":23},\"flightDurations\":{\"scheduledBlockMinutes\":85,\"blockMinutes\":78,\"scheduledAirMinutes\":42,\"airMinutes\":45,\"scheduledTaxiOutMinutes\":4,\"taxiOutMinutes\":25,\"scheduledTaxiInMinutes\":39,\"taxiInMinutes\":8},\"airportResources\":{\"departureTerminal\":\"A\",\"departureGate\":\"A14\",\"arrivalTerminal\":\"2\",\"arrivalGate\":\"C68\",\"baggage\":\"F\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"319\",\"actualEquipmentIataCode\":\"319\",\"tailNumber\":\"N339NB\"}},{\"flightId\":956246810,\"carrierFsCode\":\"AA\",\"flightNumber\":\"241\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T07:00:00.000\",\"dateUtc\":\"2018-04-18T11:00:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T08:27:00.000\",\"dateUtc\":\"2018-04-18T12:27:00.000Z\"},\"status\":\"L\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"RJY\",\"restrictions\":\"\"},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T07:00:00.000\",\"dateUtc\":\"2018-04-18T11:00:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T08:27:00.000\",\"dateUtc\":\"2018-04-18T12:27:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T07:00:00.000\",\"dateUtc\":\"2018-04-18T11:00:00.000Z\"},\"estimatedGateDeparture\":{\"dateLocal\":\"2018-04-18T06:51:00.000\",\"dateUtc\":\"2018-04-18T10:51:00.000Z\"},\"actualGateDeparture\":{\"dateLocal\":\"2018-04-18T06:51:00.000\",\"dateUtc\":\"2018-04-18T10:51:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T07:23:00.000\",\"dateUtc\":\"2018-04-18T11:23:00.000Z\"},\"estimatedRunwayDeparture\":{\"dateLocal\":\"2018-04-18T07:12:00.000\",\"dateUtc\":\"2018-04-18T11:12:00.000Z\"},\"actualRunwayDeparture\":{\"dateLocal\":\"2018-04-18T07:12:00.000\",\"dateUtc\":\"2018-04-18T11:12:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T08:27:00.000\",\"dateUtc\":\"2018-04-18T12:27:00.000Z\"},\"estimatedGateArrival\":{\"dateLocal\":\"2018-04-18T08:16:00.000\",\"dateUtc\":\"2018-04-18T12:16:00.000Z\"},\"actualGateArrival\":{\"dateLocal\":\"2018-04-18T08:16:00.000\",\"dateUtc\":\"2018-04-18T12:16:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T08:13:00.000\",\"dateUtc\":\"2018-04-18T12:13:00.000Z\"},\"estimatedRunwayArrival\":{\"dateLocal\":\"2018-04-18T08:00:00.000\",\"dateUtc\":\"2018-04-18T12:00:00.000Z\"},\"actualRunwayArrival\":{\"dateLocal\":\"2018-04-18T08:00:00.000\",\"dateUtc\":\"2018-04-18T12:00:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"BA\",\"flightNumber\":\"5615\",\"relationship\":\"L\"},{\"fsCode\":\"JL\",\"flightNumber\":\"7453\",\"relationship\":\"L\"},{\"fsCode\":\"MH\",\"flightNumber\":\"9570\",\"relationship\":\"L\"},{\"fsCode\":\"QF\",\"flightNumber\":\"3248\",\"relationship\":\"L\"}],\"flightDurations\":{\"scheduledBlockMinutes\":87,\"blockMinutes\":85,\"scheduledAirMinutes\":50,\"airMinutes\":48,\"scheduledTaxiOutMinutes\":23,\"taxiOutMinutes\":21,\"scheduledTaxiInMinutes\":14,\"taxiInMinutes\":16},\"airportResources\":{\"departureTerminal\":\"B\",\"departureGate\":\"B6\",\"arrivalTerminal\":\"8\",\"arrivalGate\":\"38\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"73H\",\"actualEquipmentIataCode\":\"738\",\"tailNumber\":\"N932NN\"}},{\"flightId\":956272369,\"carrierFsCode\":\"9E\",\"flightNumber\":\"3397\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T07:05:00.000\",\"dateUtc\":\"2018-04-18T11:05:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T08:33:00.000\",\"dateUtc\":\"2018-04-18T12:33:00.000Z\"},\"status\":\"L\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"FY\",\"restrictions\":\"\"},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T07:05:00.000\",\"dateUtc\":\"2018-04-18T11:05:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T08:33:00.000\",\"dateUtc\":\"2018-04-18T12:33:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T07:05:00.000\",\"dateUtc\":\"2018-04-18T11:05:00.000Z\"},\"estimatedGateDeparture\":{\"dateLocal\":\"2018-04-18T07:15:00.000\",\"dateUtc\":\"2018-04-18T11:15:00.000Z\"},\"actualGateDeparture\":{\"dateLocal\":\"2018-04-18T07:15:00.000\",\"dateUtc\":\"2018-04-18T11:15:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T07:20:00.000\",\"dateUtc\":\"2018-04-18T11:20:00.000Z\"},\"estimatedRunwayDeparture\":{\"dateLocal\":\"2018-04-18T07:45:00.000\",\"dateUtc\":\"2018-04-18T11:45:00.000Z\"},\"actualRunwayDeparture\":{\"dateLocal\":\"2018-04-18T07:45:00.000\",\"dateUtc\":\"2018-04-18T11:45:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T08:33:00.000\",\"dateUtc\":\"2018-04-18T12:33:00.000Z\"},\"estimatedGateArrival\":{\"dateLocal\":\"2018-04-18T08:35:00.000\",\"dateUtc\":\"2018-04-18T12:35:00.000Z\"},\"actualGateArrival\":{\"dateLocal\":\"2018-04-18T08:35:00.000\",\"dateUtc\":\"2018-04-18T12:35:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T08:02:00.000\",\"dateUtc\":\"2018-04-18T12:02:00.000Z\"},\"estimatedRunwayArrival\":{\"dateLocal\":\"2018-04-18T08:30:00.000\",\"dateUtc\":\"2018-04-18T12:30:00.000Z\"},\"actualRunwayArrival\":{\"dateLocal\":\"2018-04-18T08:30:00.000\",\"dateUtc\":\"2018-04-18T12:30:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"AR\",\"flightNumber\":\"7063\",\"relationship\":\"L\"},{\"fsCode\":\"AZ\",\"flightNumber\":\"5919\",\"relationship\":\"L\"},{\"fsCode\":\"CZ\",\"flightNumber\":\"1015\",\"relationship\":\"L\"},{\"fsCode\":\"KE\",\"flightNumber\":\"7488\",\"relationship\":\"L\"},{\"fsCode\":\"VS\",\"flightNumber\":\"4798\",\"relationship\":\"L\"},{\"fsCode\":\"WS\",\"flightNumber\":\"6420\",\"relationship\":\"L\"},{\"fsCode\":\"DL\",\"flightNumber\":\"3397\",\"relationship\":\"S\"}],\"delays\":{\"departureGateDelayMinutes\":10,\"departureRunwayDelayMinutes\":25,\"arrivalGateDelayMinutes\":2,\"arrivalRunwayDelayMinutes\":28},\"flightDurations\":{\"scheduledBlockMinutes\":88,\"blockMinutes\":80,\"scheduledAirMinutes\":42,\"airMinutes\":45,\"scheduledTaxiOutMinutes\":15,\"taxiOutMinutes\":30,\"scheduledTaxiInMinutes\":31,\"taxiInMinutes\":5},\"airportResources\":{\"departureTerminal\":\"A\",\"departureGate\":\"A11\",\"arrivalTerminal\":\"4\",\"arrivalGate\":\"B47\",\"baggage\":\"T4\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"CR9\",\"actualEquipmentIataCode\":\"CR9\",\"tailNumber\":\"N695CA\"}},{\"flightId\":956260600,\"carrierFsCode\":\"B6\",\"flightNumber\":\"2317\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T08:16:00.000\",\"dateUtc\":\"2018-04-18T12:16:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T09:34:00.000\",\"dateUtc\":\"2018-04-18T13:34:00.000Z\"},\"status\":\"L\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"RFJY\",\"restrictions\":\"\"},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T08:16:00.000\",\"dateUtc\":\"2018-04-18T12:16:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T09:34:00.000\",\"dateUtc\":\"2018-04-18T13:34:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T08:16:00.000\",\"dateUtc\":\"2018-04-18T12:16:00.000Z\"},\"estimatedGateDeparture\":{\"dateLocal\":\"2018-04-18T08:14:00.000\",\"dateUtc\":\"2018-04-18T12:14:00.000Z\"},\"actualGateDeparture\":{\"dateLocal\":\"2018-04-18T08:14:00.000\",\"dateUtc\":\"2018-04-18T12:14:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T08:30:00.000\",\"dateUtc\":\"2018-04-18T12:30:00.000Z\"},\"estimatedRunwayDeparture\":{\"dateLocal\":\"2018-04-18T08:41:00.000\",\"dateUtc\":\"2018-04-18T12:41:00.000Z\"},\"actualRunwayDeparture\":{\"dateLocal\":\"2018-04-18T08:41:00.000\",\"dateUtc\":\"2018-04-18T12:41:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T09:34:00.000\",\"dateUtc\":\"2018-04-18T13:34:00.000Z\"},\"estimatedGateArrival\":{\"dateLocal\":\"2018-04-18T09:29:00.000\",\"dateUtc\":\"2018-04-18T13:29:00.000Z\"},\"actualGateArrival\":{\"dateLocal\":\"2018-04-18T09:29:00.000\",\"dateUtc\":\"2018-04-18T13:29:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T09:13:00.000\",\"dateUtc\":\"2018-04-18T13:13:00.000Z\"},\"estimatedRunwayArrival\":{\"dateLocal\":\"2018-04-18T09:24:00.000\",\"dateUtc\":\"2018-04-18T13:24:00.000Z\"},\"actualRunwayArrival\":{\"dateLocal\":\"2018-04-18T09:24:00.000\",\"dateUtc\":\"2018-04-18T13:24:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"EI\",\"flightNumber\":\"5023\",\"relationship\":\"L\"},{\"fsCode\":\"EK\",\"flightNumber\":\"6870\",\"relationship\":\"L\"},{\"fsCode\":\"EY\",\"flightNumber\":\"8244\",\"relationship\":\"L\"},{\"fsCode\":\"SA\",\"flightNumber\":\"7335\",\"relationship\":\"L\"}],\"delays\":{\"departureRunwayDelayMinutes\":11,\"arrivalRunwayDelayMinutes\":11},\"flightDurations\":{\"scheduledBlockMinutes\":78,\"blockMinutes\":75,\"scheduledAirMinutes\":43,\"airMinutes\":43,\"scheduledTaxiOutMinutes\":14,\"taxiOutMinutes\":27,\"scheduledTaxiInMinutes\":21,\"taxiInMinutes\":5},\"airportResources\":{\"departureTerminal\":\"C\",\"departureGate\":\"C17\",\"arrivalTerminal\":\"5\",\"arrivalGate\":\"2\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"E90\",\"actualEquipmentIataCode\":\"E90\",\"tailNumber\":\"N274JB\"}},{\"flightId\":956573625,\"carrierFsCode\":\"1I\",\"flightNumber\":\"209\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"divertedAirportFsCode\":\"BOS\",\"departureDate\":{\"dateLocal\":\"2018-04-18T08:45:00.000\",\"dateUtc\":\"2018-04-18T12:45:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T09:34:00.000\",\"dateUtc\":\"2018-04-18T13:34:00.000Z\"},\"status\":\"R\",\"operationalTimes\":{\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T08:45:00.000\",\"dateUtc\":\"2018-04-18T12:45:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T09:16:00.000\",\"dateUtc\":\"2018-04-18T13:16:00.000Z\"},\"estimatedRunwayDeparture\":{\"dateLocal\":\"2018-04-18T08:51:00.000\",\"dateUtc\":\"2018-04-18T12:51:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T09:34:00.000\",\"dateUtc\":\"2018-04-18T13:34:00.000Z\"}},\"flightDurations\":{\"scheduledAirMinutes\":18,\"scheduledTaxiOutMinutes\":31},\"flightEquipment\":{\"actualEquipmentIataCode\":\"CCJ\",\"tailNumber\":\"N209QS\"}},{\"flightId\":956273900,\"carrierFsCode\":\"9E\",\"flightNumber\":\"5220\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T09:10:00.000\",\"dateUtc\":\"2018-04-18T13:10:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T10:33:00.000\",\"dateUtc\":\"2018-04-18T14:33:00.000Z\"},\"status\":\"L\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"FY\",\"restrictions\":\"\"},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T09:10:00.000\",\"dateUtc\":\"2018-04-18T13:10:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T10:33:00.000\",\"dateUtc\":\"2018-04-18T14:33:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T09:10:00.000\",\"dateUtc\":\"2018-04-18T13:10:00.000Z\"},\"estimatedGateDeparture\":{\"dateLocal\":\"2018-04-18T09:05:00.000\",\"dateUtc\":\"2018-04-18T13:05:00.000Z\"},\"actualGateDeparture\":{\"dateLocal\":\"2018-04-18T09:05:00.000\",\"dateUtc\":\"2018-04-18T13:05:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T09:26:00.000\",\"dateUtc\":\"2018-04-18T13:26:00.000Z\"},\"estimatedRunwayDeparture\":{\"dateLocal\":\"2018-04-18T09:32:00.000\",\"dateUtc\":\"2018-04-18T13:32:00.000Z\"},\"actualRunwayDeparture\":{\"dateLocal\":\"2018-04-18T09:32:00.000\",\"dateUtc\":\"2018-04-18T13:32:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T10:33:00.000\",\"dateUtc\":\"2018-04-18T14:33:00.000Z\"},\"estimatedGateArrival\":{\"dateLocal\":\"2018-04-18T10:29:00.000\",\"dateUtc\":\"2018-04-18T14:29:00.000Z\"},\"actualGateArrival\":{\"dateLocal\":\"2018-04-18T10:29:00.000\",\"dateUtc\":\"2018-04-18T14:29:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T10:08:00.000\",\"dateUtc\":\"2018-04-18T14:08:00.000Z\"},\"estimatedRunwayArrival\":{\"dateLocal\":\"2018-04-18T10:16:00.000\",\"dateUtc\":\"2018-04-18T14:16:00.000Z\"},\"actualRunwayArrival\":{\"dateLocal\":\"2018-04-18T10:16:00.000\",\"dateUtc\":\"2018-04-18T14:16:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"AR\",\"flightNumber\":\"7065\",\"relationship\":\"L\"},{\"fsCode\":\"KE\",\"flightNumber\":\"7490\",\"relationship\":\"L\"},{\"fsCode\":\"VS\",\"flightNumber\":\"4658\",\"relationship\":\"L\"},{\"fsCode\":\"WS\",\"flightNumber\":\"6425\",\"relationship\":\"L\"},{\"fsCode\":\"DL\",\"flightNumber\":\"5220\",\"relationship\":\"S\"}],\"delays\":{\"departureRunwayDelayMinutes\":6,\"arrivalRunwayDelayMinutes\":8},\"flightDurations\":{\"scheduledBlockMinutes\":83,\"blockMinutes\":84,\"scheduledAirMinutes\":42,\"airMinutes\":44,\"scheduledTaxiOutMinutes\":16,\"taxiOutMinutes\":27,\"scheduledTaxiInMinutes\":25,\"taxiInMinutes\":13},\"airportResources\":{\"departureTerminal\":\"A\",\"departureGate\":\"A10\",\"arrivalTerminal\":\"2\",\"arrivalGate\":\"C65\",\"baggage\":\"E2\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"CR9\",\"actualEquipmentIataCode\":\"CR9\",\"tailNumber\":\"N316PQ\"}},{\"flightId\":956247266,\"carrierFsCode\":\"AA\",\"flightNumber\":\"2740\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T09:40:00.000\",\"dateUtc\":\"2018-04-18T13:40:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T11:04:00.000\",\"dateUtc\":\"2018-04-18T15:04:00.000Z\"},\"status\":\"L\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"RJY\",\"restrictions\":\"\"},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T09:40:00.000\",\"dateUtc\":\"2018-04-18T13:40:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T11:04:00.000\",\"dateUtc\":\"2018-04-18T15:04:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T09:40:00.000\",\"dateUtc\":\"2018-04-18T13:40:00.000Z\"},\"estimatedGateDeparture\":{\"dateLocal\":\"2018-04-18T09:35:00.000\",\"dateUtc\":\"2018-04-18T13:35:00.000Z\"},\"actualGateDeparture\":{\"dateLocal\":\"2018-04-18T09:35:00.000\",\"dateUtc\":\"2018-04-18T13:35:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T10:04:00.000\",\"dateUtc\":\"2018-04-18T14:04:00.000Z\"},\"estimatedRunwayDeparture\":{\"dateLocal\":\"2018-04-18T09:55:00.000\",\"dateUtc\":\"2018-04-18T13:55:00.000Z\"},\"actualRunwayDeparture\":{\"dateLocal\":\"2018-04-18T09:55:00.000\",\"dateUtc\":\"2018-04-18T13:55:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T11:04:00.000\",\"dateUtc\":\"2018-04-18T15:04:00.000Z\"},\"estimatedGateArrival\":{\"dateLocal\":\"2018-04-18T10:44:00.000\",\"dateUtc\":\"2018-04-18T14:44:00.000Z\"},\"actualGateArrival\":{\"dateLocal\":\"2018-04-18T10:44:00.000\",\"dateUtc\":\"2018-04-18T14:44:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T10:52:00.000\",\"dateUtc\":\"2018-04-18T14:52:00.000Z\"},\"estimatedRunwayArrival\":{\"dateLocal\":\"2018-04-18T10:39:00.000\",\"dateUtc\":\"2018-04-18T14:39:00.000Z\"},\"actualRunwayArrival\":{\"dateLocal\":\"2018-04-18T10:39:00.000\",\"dateUtc\":\"2018-04-18T14:39:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"BA\",\"flightNumber\":\"2433\",\"relationship\":\"L\"},{\"fsCode\":\"CX\",\"flightNumber\":\"7513\",\"relationship\":\"L\"},{\"fsCode\":\"JJ\",\"flightNumber\":\"2197\",\"relationship\":\"L\"},{\"fsCode\":\"JL\",\"flightNumber\":\"7455\",\"relationship\":\"L\"},{\"fsCode\":\"LA\",\"flightNumber\":\"6499\",\"relationship\":\"L\"},{\"fsCode\":\"QF\",\"flightNumber\":\"4131\",\"relationship\":\"L\"}],\"flightDurations\":{\"scheduledBlockMinutes\":84,\"blockMinutes\":69,\"scheduledAirMinutes\":48,\"airMinutes\":44,\"scheduledTaxiOutMinutes\":24,\"taxiOutMinutes\":20,\"scheduledTaxiInMinutes\":12,\"taxiInMinutes\":5},\"airportResources\":{\"departureTerminal\":\"B\",\"departureGate\":\"B30\",\"arrivalTerminal\":\"8\",\"arrivalGate\":\"36\",\"baggage\":\"7\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"32B\",\"tailNumber\":\"N117AN\"}},{\"flightId\":956261007,\"carrierFsCode\":\"B6\",\"flightNumber\":\"717\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T10:49:00.000\",\"dateUtc\":\"2018-04-18T14:49:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T12:03:00.000\",\"dateUtc\":\"2018-04-18T16:03:00.000Z\"},\"status\":\"A\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"RFJY\",\"restrictions\":\"\"},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T10:49:00.000\",\"dateUtc\":\"2018-04-18T14:49:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T12:03:00.000\",\"dateUtc\":\"2018-04-18T16:03:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T10:49:00.000\",\"dateUtc\":\"2018-04-18T14:49:00.000Z\"},\"estimatedGateDeparture\":{\"dateLocal\":\"2018-04-18T10:58:00.000\",\"dateUtc\":\"2018-04-18T14:58:00.000Z\"},\"actualGateDeparture\":{\"dateLocal\":\"2018-04-18T10:58:00.000\",\"dateUtc\":\"2018-04-18T14:58:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T11:03:00.000\",\"dateUtc\":\"2018-04-18T15:03:00.000Z\"},\"estimatedRunwayDeparture\":{\"dateLocal\":\"2018-04-18T11:17:00.000\",\"dateUtc\":\"2018-04-18T15:17:00.000Z\"},\"actualRunwayDeparture\":{\"dateLocal\":\"2018-04-18T11:17:00.000\",\"dateUtc\":\"2018-04-18T15:17:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T12:03:00.000\",\"dateUtc\":\"2018-04-18T16:03:00.000Z\"},\"estimatedGateArrival\":{\"dateLocal\":\"2018-04-18T12:04:00.000\",\"dateUtc\":\"2018-04-18T16:04:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T11:46:00.000\",\"dateUtc\":\"2018-04-18T15:46:00.000Z\"},\"estimatedRunwayArrival\":{\"dateLocal\":\"2018-04-18T12:02:00.000\",\"dateUtc\":\"2018-04-18T16:02:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"EI\",\"flightNumber\":\"5017\",\"relationship\":\"L\"},{\"fsCode\":\"EY\",\"flightNumber\":\"8278\",\"relationship\":\"L\"}],\"delays\":{\"departureGateDelayMinutes\":9,\"departureRunwayDelayMinutes\":14,\"arrivalGateDelayMinutes\":1,\"arrivalRunwayDelayMinutes\":16},\"flightDurations\":{\"scheduledBlockMinutes\":74,\"scheduledAirMinutes\":43,\"scheduledTaxiOutMinutes\":14,\"taxiOutMinutes\":19,\"scheduledTaxiInMinutes\":17},\"airportResources\":{\"departureTerminal\":\"C\",\"departureGate\":\"C33\",\"arrivalTerminal\":\"5\",\"arrivalGate\":\"21\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"E90\",\"actualEquipmentIataCode\":\"E90\",\"tailNumber\":\"N53551\"}},{\"flightId\":956272868,\"carrierFsCode\":\"9E\",\"flightNumber\":\"4076\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T11:05:00.000\",\"dateUtc\":\"2018-04-18T15:05:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T12:30:00.000\",\"dateUtc\":\"2018-04-18T16:30:00.000Z\"},\"status\":\"A\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"FY\",\"restrictions\":\"\"},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T11:05:00.000\",\"dateUtc\":\"2018-04-18T15:05:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T12:30:00.000\",\"dateUtc\":\"2018-04-18T16:30:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T11:05:00.000\",\"dateUtc\":\"2018-04-18T15:05:00.000Z\"},\"estimatedGateDeparture\":{\"dateLocal\":\"2018-04-18T11:03:00.000\",\"dateUtc\":\"2018-04-18T15:03:00.000Z\"},\"actualGateDeparture\":{\"dateLocal\":\"2018-04-18T11:03:00.000\",\"dateUtc\":\"2018-04-18T15:03:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T11:14:00.000\",\"dateUtc\":\"2018-04-18T15:14:00.000Z\"},\"estimatedRunwayDeparture\":{\"dateLocal\":\"2018-04-18T11:26:00.000\",\"dateUtc\":\"2018-04-18T15:26:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T12:30:00.000\",\"dateUtc\":\"2018-04-18T16:30:00.000Z\"},\"estimatedGateArrival\":{\"dateLocal\":\"2018-04-18T12:09:00.000\",\"dateUtc\":\"2018-04-18T16:09:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T11:56:00.000\",\"dateUtc\":\"2018-04-18T15:56:00.000Z\"},\"estimatedRunwayArrival\":{\"dateLocal\":\"2018-04-18T12:04:00.000\",\"dateUtc\":\"2018-04-18T16:04:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"AM\",\"flightNumber\":\"5740\",\"relationship\":\"L\"},{\"fsCode\":\"AR\",\"flightNumber\":\"7064\",\"relationship\":\"L\"},{\"fsCode\":\"AZ\",\"flightNumber\":\"5990\",\"relationship\":\"L\"},{\"fsCode\":\"MU\",\"flightNumber\":\"8875\",\"relationship\":\"L\"},{\"fsCode\":\"UX\",\"flightNumber\":\"3328\",\"relationship\":\"L\"},{\"fsCode\":\"VS\",\"flightNumber\":\"3093\",\"relationship\":\"L\"},{\"fsCode\":\"WS\",\"flightNumber\":\"7563\",\"relationship\":\"L\"},{\"fsCode\":\"DL\",\"flightNumber\":\"4076\",\"relationship\":\"S\"}],\"delays\":{\"departureRunwayDelayMinutes\":12,\"arrivalRunwayDelayMinutes\":8},\"flightDurations\":{\"scheduledBlockMinutes\":85,\"scheduledAirMinutes\":42,\"scheduledTaxiOutMinutes\":9,\"scheduledTaxiInMinutes\":34},\"airportResources\":{\"departureTerminal\":\"A\",\"departureGate\":\"A2\",\"arrivalTerminal\":\"2\",\"arrivalGate\":\"C60\",\"baggage\":\"E1\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"CR9\",\"actualEquipmentIataCode\":\"CR9\",\"tailNumber\":\"N313PQ\"}},{\"flightId\":956260227,\"carrierFsCode\":\"B6\",\"flightNumber\":\"117\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T11:49:00.000\",\"dateUtc\":\"2018-04-18T15:49:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T13:11:00.000\",\"dateUtc\":\"2018-04-18T17:11:00.000Z\"},\"status\":\"S\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"RFJY\",\"restrictions\":\"\"},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T11:49:00.000\",\"dateUtc\":\"2018-04-18T15:49:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T13:11:00.000\",\"dateUtc\":\"2018-04-18T17:11:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T11:49:00.000\",\"dateUtc\":\"2018-04-18T15:49:00.000Z\"},\"estimatedGateDeparture\":{\"dateLocal\":\"2018-04-18T11:49:00.000\",\"dateUtc\":\"2018-04-18T15:49:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T12:03:00.000\",\"dateUtc\":\"2018-04-18T16:03:00.000Z\"},\"estimatedRunwayDeparture\":{\"dateLocal\":\"2018-04-18T12:03:00.000\",\"dateUtc\":\"2018-04-18T16:03:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T13:11:00.000\",\"dateUtc\":\"2018-04-18T17:11:00.000Z\"},\"estimatedGateArrival\":{\"dateLocal\":\"2018-04-18T12:54:00.000\",\"dateUtc\":\"2018-04-18T16:54:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T12:46:00.000\",\"dateUtc\":\"2018-04-18T16:46:00.000Z\"},\"estimatedRunwayArrival\":{\"dateLocal\":\"2018-04-18T12:47:00.000\",\"dateUtc\":\"2018-04-18T16:47:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"AT\",\"flightNumber\":\"9509\",\"relationship\":\"L\"},{\"fsCode\":\"EI\",\"flightNumber\":\"5009\",\"relationship\":\"L\"}],\"delays\":{\"arrivalRunwayDelayMinutes\":1},\"flightDurations\":{\"scheduledBlockMinutes\":82,\"scheduledAirMinutes\":43,\"scheduledTaxiOutMinutes\":14,\"scheduledTaxiInMinutes\":25},\"airportResources\":{\"departureTerminal\":\"C\",\"departureGate\":\"C16\",\"arrivalTerminal\":\"5\",\"arrivalGate\":\"2\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"E90\",\"actualEquipmentIataCode\":\"E90\",\"tailNumber\":\"N284JB\"}},{\"flightId\":956245204,\"carrierFsCode\":\"AA\",\"flightNumber\":\"1039\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T12:10:00.000\",\"dateUtc\":\"2018-04-18T16:10:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T13:31:00.000\",\"dateUtc\":\"2018-04-18T17:31:00.000Z\"},\"status\":\"S\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"RJY\",\"restrictions\":\"\"},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T12:10:00.000\",\"dateUtc\":\"2018-04-18T16:10:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T13:31:00.000\",\"dateUtc\":\"2018-04-18T17:31:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T12:10:00.000\",\"dateUtc\":\"2018-04-18T16:10:00.000Z\"},\"estimatedGateDeparture\":{\"dateLocal\":\"2018-04-18T12:10:00.000\",\"dateUtc\":\"2018-04-18T16:10:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T12:30:00.000\",\"dateUtc\":\"2018-04-18T16:30:00.000Z\"},\"estimatedRunwayDeparture\":{\"dateLocal\":\"2018-04-18T12:30:00.000\",\"dateUtc\":\"2018-04-18T16:30:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T13:31:00.000\",\"dateUtc\":\"2018-04-18T17:31:00.000Z\"},\"estimatedGateArrival\":{\"dateLocal\":\"2018-04-18T13:26:00.000\",\"dateUtc\":\"2018-04-18T17:26:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T13:21:00.000\",\"dateUtc\":\"2018-04-18T17:21:00.000Z\"},\"estimatedRunwayArrival\":{\"dateLocal\":\"2018-04-18T13:17:00.000\",\"dateUtc\":\"2018-04-18T17:17:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"IB\",\"flightNumber\":\"4323\",\"relationship\":\"L\"},{\"fsCode\":\"JJ\",\"flightNumber\":\"2193\",\"relationship\":\"L\"},{\"fsCode\":\"LA\",\"flightNumber\":\"6777\",\"relationship\":\"L\"},{\"fsCode\":\"QF\",\"flightNumber\":\"4453\",\"relationship\":\"L\"}],\"flightDurations\":{\"scheduledBlockMinutes\":81,\"scheduledAirMinutes\":51,\"scheduledTaxiOutMinutes\":20,\"scheduledTaxiInMinutes\":10},\"airportResources\":{\"departureTerminal\":\"B\",\"departureGate\":\"B35\",\"arrivalTerminal\":\"8\",\"arrivalGate\":\"36\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"32B\",\"tailNumber\":\"N109NN\"}},{\"flightId\":956272492,\"carrierFsCode\":\"9E\",\"flightNumber\":\"3430\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T13:20:00.000\",\"dateUtc\":\"2018-04-18T17:20:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T14:43:00.000\",\"dateUtc\":\"2018-04-18T18:43:00.000Z\"},\"status\":\"S\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"FY\",\"restrictions\":\"\"},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T13:20:00.000\",\"dateUtc\":\"2018-04-18T17:20:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T14:43:00.000\",\"dateUtc\":\"2018-04-18T18:43:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T13:20:00.000\",\"dateUtc\":\"2018-04-18T17:20:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T13:27:00.000\",\"dateUtc\":\"2018-04-18T17:27:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T14:43:00.000\",\"dateUtc\":\"2018-04-18T18:43:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T14:10:00.000\",\"dateUtc\":\"2018-04-18T18:10:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"AF\",\"flightNumber\":\"5662\",\"relationship\":\"L\"},{\"fsCode\":\"AM\",\"flightNumber\":\"5503\",\"relationship\":\"L\"},{\"fsCode\":\"AR\",\"flightNumber\":\"7027\",\"relationship\":\"L\"},{\"fsCode\":\"AZ\",\"flightNumber\":\"5921\",\"relationship\":\"L\"},{\"fsCode\":\"KL\",\"flightNumber\":\"5423\",\"relationship\":\"L\"},{\"fsCode\":\"MU\",\"flightNumber\":\"8876\",\"relationship\":\"L\"},{\"fsCode\":\"OK\",\"flightNumber\":\"3027\",\"relationship\":\"L\"},{\"fsCode\":\"VS\",\"flightNumber\":\"4606\",\"relationship\":\"L\"},{\"fsCode\":\"WS\",\"flightNumber\":\"7561\",\"relationship\":\"L\"},{\"fsCode\":\"DL\",\"flightNumber\":\"3430\",\"relationship\":\"S\"}],\"flightDurations\":{\"scheduledBlockMinutes\":83,\"scheduledAirMinutes\":43,\"scheduledTaxiOutMinutes\":7,\"scheduledTaxiInMinutes\":33},\"airportResources\":{\"departureTerminal\":\"A\",\"departureGate\":\"A11\",\"arrivalTerminal\":\"4\",\"arrivalGate\":\"B44\",\"baggage\":\"T4\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"CR9\",\"actualEquipmentIataCode\":\"CR9\",\"tailNumber\":\"N336PQ\"}},{\"flightId\":956245607,\"carrierFsCode\":\"AA\",\"flightNumber\":\"1422\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T14:40:00.000\",\"dateUtc\":\"2018-04-18T18:40:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T16:07:00.000\",\"dateUtc\":\"2018-04-18T20:07:00.000Z\"},\"status\":\"S\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"RJY\",\"restrictions\":\"\",\"uplines\":[{\"fsCode\":\"JFK\",\"flightId\":956245578}]},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T14:40:00.000\",\"dateUtc\":\"2018-04-18T18:40:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T16:07:00.000\",\"dateUtc\":\"2018-04-18T20:07:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T14:40:00.000\",\"dateUtc\":\"2018-04-18T18:40:00.000Z\"},\"estimatedGateDeparture\":{\"dateLocal\":\"2018-04-18T14:40:00.000\",\"dateUtc\":\"2018-04-18T18:40:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T15:04:00.000\",\"dateUtc\":\"2018-04-18T19:04:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T16:07:00.000\",\"dateUtc\":\"2018-04-18T20:07:00.000Z\"},\"estimatedGateArrival\":{\"dateLocal\":\"2018-04-18T16:07:00.000\",\"dateUtc\":\"2018-04-18T20:07:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T15:54:00.000\",\"dateUtc\":\"2018-04-18T19:54:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"AY\",\"flightNumber\":\"5694\",\"relationship\":\"L\"},{\"fsCode\":\"BA\",\"flightNumber\":\"2383\",\"relationship\":\"L\"},{\"fsCode\":\"IB\",\"flightNumber\":\"4329\",\"relationship\":\"L\"},{\"fsCode\":\"JJ\",\"flightNumber\":\"2129\",\"relationship\":\"L\"},{\"fsCode\":\"LA\",\"flightNumber\":\"6505\",\"relationship\":\"L\"},{\"fsCode\":\"MH\",\"flightNumber\":\"9623\",\"relationship\":\"L\"},{\"fsCode\":\"QF\",\"flightNumber\":\"4644\",\"relationship\":\"L\"},{\"fsCode\":\"XL\",\"flightNumber\":\"6302\",\"relationship\":\"L\"}],\"flightDurations\":{\"scheduledBlockMinutes\":87,\"scheduledAirMinutes\":50,\"scheduledTaxiOutMinutes\":24,\"scheduledTaxiInMinutes\":13},\"airportResources\":{\"departureTerminal\":\"B\",\"departureGate\":\"B32\",\"arrivalTerminal\":\"8\",\"arrivalGate\":\"36\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"32B\",\"tailNumber\":\"N117AN\"}},{\"flightId\":956272478,\"carrierFsCode\":\"9E\",\"flightNumber\":\"3478\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T15:00:00.000\",\"dateUtc\":\"2018-04-18T19:00:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T16:30:00.000\",\"dateUtc\":\"2018-04-18T20:30:00.000Z\"},\"status\":\"S\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"FY\",\"restrictions\":\"\"},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T15:00:00.000\",\"dateUtc\":\"2018-04-18T19:00:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T16:30:00.000\",\"dateUtc\":\"2018-04-18T20:30:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T15:00:00.000\",\"dateUtc\":\"2018-04-18T19:00:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T15:03:00.000\",\"dateUtc\":\"2018-04-18T19:03:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T16:30:00.000\",\"dateUtc\":\"2018-04-18T20:30:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T15:46:00.000\",\"dateUtc\":\"2018-04-18T19:46:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"AF\",\"flightNumber\":\"2741\",\"relationship\":\"L\"},{\"fsCode\":\"AM\",\"flightNumber\":\"5505\",\"relationship\":\"L\"},{\"fsCode\":\"AZ\",\"flightNumber\":\"5920\",\"relationship\":\"L\"},{\"fsCode\":\"G3\",\"flightNumber\":\"8063\",\"relationship\":\"L\"},{\"fsCode\":\"KL\",\"flightNumber\":\"5741\",\"relationship\":\"L\"},{\"fsCode\":\"UX\",\"flightNumber\":\"3313\",\"relationship\":\"L\"},{\"fsCode\":\"VS\",\"flightNumber\":\"4656\",\"relationship\":\"L\"},{\"fsCode\":\"WS\",\"flightNumber\":\"6827\",\"relationship\":\"L\"},{\"fsCode\":\"DL\",\"flightNumber\":\"3478\",\"relationship\":\"S\"}],\"flightDurations\":{\"scheduledBlockMinutes\":90,\"scheduledAirMinutes\":43,\"scheduledTaxiOutMinutes\":3,\"scheduledTaxiInMinutes\":44},\"airportResources\":{\"departureTerminal\":\"A\",\"departureGate\":\"A14\",\"arrivalTerminal\":\"4\",\"arrivalGate\":\"B48\",\"baggage\":\"T4\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"CR9\",\"actualEquipmentIataCode\":\"CR9\",\"tailNumber\":\"N313PQ\"}},{\"flightId\":956260811,\"carrierFsCode\":\"B6\",\"flightNumber\":\"417\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T15:03:00.000\",\"dateUtc\":\"2018-04-18T19:03:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T16:30:00.000\",\"dateUtc\":\"2018-04-18T20:30:00.000Z\"},\"status\":\"S\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"RFJY\",\"restrictions\":\"\"},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T15:03:00.000\",\"dateUtc\":\"2018-04-18T19:03:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T16:30:00.000\",\"dateUtc\":\"2018-04-18T20:30:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T15:03:00.000\",\"dateUtc\":\"2018-04-18T19:03:00.000Z\"},\"estimatedGateDeparture\":{\"dateLocal\":\"2018-04-18T15:03:00.000\",\"dateUtc\":\"2018-04-18T19:03:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T15:08:00.000\",\"dateUtc\":\"2018-04-18T19:08:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T16:30:00.000\",\"dateUtc\":\"2018-04-18T20:30:00.000Z\"},\"estimatedGateArrival\":{\"dateLocal\":\"2018-04-18T16:30:00.000\",\"dateUtc\":\"2018-04-18T20:30:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T15:52:00.000\",\"dateUtc\":\"2018-04-18T19:52:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"AT\",\"flightNumber\":\"9513\",\"relationship\":\"L\"},{\"fsCode\":\"EI\",\"flightNumber\":\"5011\",\"relationship\":\"L\"},{\"fsCode\":\"EY\",\"flightNumber\":\"8247\",\"relationship\":\"L\"},{\"fsCode\":\"QR\",\"flightNumber\":\"3914\",\"relationship\":\"L\"},{\"fsCode\":\"SQ\",\"flightNumber\":\"1451\",\"relationship\":\"L\"},{\"fsCode\":\"TP\",\"flightNumber\":\"6385\",\"relationship\":\"L\"}],\"flightDurations\":{\"scheduledBlockMinutes\":87,\"scheduledAirMinutes\":44,\"scheduledTaxiOutMinutes\":5,\"scheduledTaxiInMinutes\":38},\"airportResources\":{\"departureTerminal\":\"C\",\"departureGate\":\"C33\",\"arrivalTerminal\":\"5\",\"arrivalGate\":\"3\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"E90\",\"actualEquipmentIataCode\":\"E90\"}},{\"flightId\":956270733,\"carrierFsCode\":\"DL\",\"flightNumber\":\"1707\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T17:05:00.000\",\"dateUtc\":\"2018-04-18T21:05:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T18:30:00.000\",\"dateUtc\":\"2018-04-18T22:30:00.000Z\"},\"status\":\"S\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"FY\",\"restrictions\":\"\"},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T17:05:00.000\",\"dateUtc\":\"2018-04-18T21:05:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T18:30:00.000\",\"dateUtc\":\"2018-04-18T22:30:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T17:05:00.000\",\"dateUtc\":\"2018-04-18T21:05:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T17:15:00.000\",\"dateUtc\":\"2018-04-18T21:15:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T18:30:00.000\",\"dateUtc\":\"2018-04-18T22:30:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T17:57:00.000\",\"dateUtc\":\"2018-04-18T21:57:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"9W\",\"flightNumber\":\"8378\",\"relationship\":\"L\"},{\"fsCode\":\"AZ\",\"flightNumber\":\"5916\",\"relationship\":\"L\"},{\"fsCode\":\"G3\",\"flightNumber\":\"8091\",\"relationship\":\"L\"},{\"fsCode\":\"KE\",\"flightNumber\":\"7308\",\"relationship\":\"L\"},{\"fsCode\":\"KL\",\"flightNumber\":\"5967\",\"relationship\":\"L\"},{\"fsCode\":\"MU\",\"flightNumber\":\"8824\",\"relationship\":\"L\"},{\"fsCode\":\"UX\",\"flightNumber\":\"3338\",\"relationship\":\"L\"},{\"fsCode\":\"VS\",\"flightNumber\":\"2715\",\"relationship\":\"L\"},{\"fsCode\":\"WS\",\"flightNumber\":\"6829\",\"relationship\":\"L\"}],\"flightDurations\":{\"scheduledBlockMinutes\":85,\"scheduledAirMinutes\":42,\"scheduledTaxiOutMinutes\":10,\"scheduledTaxiInMinutes\":33},\"airportResources\":{\"departureTerminal\":\"A\",\"departureGate\":\"A8\",\"arrivalTerminal\":\"4\",\"arrivalGate\":\"B43\",\"baggage\":\"T4\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"319\",\"actualEquipmentIataCode\":\"319\",\"tailNumber\":\"N338NB\"}},{\"flightId\":956248874,\"carrierFsCode\":\"AX\",\"flightNumber\":\"4384\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T17:55:00.000\",\"dateUtc\":\"2018-04-18T21:55:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T19:23:00.000\",\"dateUtc\":\"2018-04-18T23:23:00.000Z\"},\"status\":\"S\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"Y\",\"restrictions\":\"\"},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T17:55:00.000\",\"dateUtc\":\"2018-04-18T21:55:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T19:23:00.000\",\"dateUtc\":\"2018-04-18T23:23:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T17:55:00.000\",\"dateUtc\":\"2018-04-18T21:55:00.000Z\"},\"estimatedGateDeparture\":{\"dateLocal\":\"2018-04-18T17:55:00.000\",\"dateUtc\":\"2018-04-18T21:55:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T18:23:00.000\",\"dateUtc\":\"2018-04-18T22:23:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T19:23:00.000\",\"dateUtc\":\"2018-04-18T23:23:00.000Z\"},\"estimatedGateArrival\":{\"dateLocal\":\"2018-04-18T19:23:00.000\",\"dateUtc\":\"2018-04-18T23:23:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T19:11:00.000\",\"dateUtc\":\"2018-04-18T23:11:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"BA\",\"flightNumber\":\"4905\",\"relationship\":\"L\"},{\"fsCode\":\"CX\",\"flightNumber\":\"7602\",\"relationship\":\"L\"},{\"fsCode\":\"LA\",\"flightNumber\":\"6490\",\"relationship\":\"L\"},{\"fsCode\":\"MH\",\"flightNumber\":\"9543\",\"relationship\":\"L\"},{\"fsCode\":\"QF\",\"flightNumber\":\"4363\",\"relationship\":\"L\"},{\"fsCode\":\"XL\",\"flightNumber\":\"6300\",\"relationship\":\"L\"},{\"fsCode\":\"AA\",\"flightNumber\":\"4384\",\"relationship\":\"S\"}],\"flightDurations\":{\"scheduledBlockMinutes\":88,\"scheduledAirMinutes\":48,\"scheduledTaxiOutMinutes\":28,\"scheduledTaxiInMinutes\":12},\"airportResources\":{\"departureTerminal\":\"B\",\"departureGate\":\"B36\",\"arrivalTerminal\":\"8\",\"arrivalGate\":\"31C\",\"baggage\":\"9\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"ER4\",\"tailNumber\":\"N613AE\"}},{\"flightId\":956260704,\"carrierFsCode\":\"B6\",\"flightNumber\":\"2717\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T18:30:00.000\",\"dateUtc\":\"2018-04-18T22:30:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T20:02:00.000\",\"dateUtc\":\"2018-04-19T00:02:00.000Z\"},\"status\":\"S\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"RFJY\",\"restrictions\":\"\"},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T18:30:00.000\",\"dateUtc\":\"2018-04-18T22:30:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T20:02:00.000\",\"dateUtc\":\"2018-04-19T00:02:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T18:30:00.000\",\"dateUtc\":\"2018-04-18T22:30:00.000Z\"},\"estimatedGateDeparture\":{\"dateLocal\":\"2018-04-18T18:30:00.000\",\"dateUtc\":\"2018-04-18T22:30:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T18:41:00.000\",\"dateUtc\":\"2018-04-18T22:41:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T20:02:00.000\",\"dateUtc\":\"2018-04-19T00:02:00.000Z\"},\"estimatedGateArrival\":{\"dateLocal\":\"2018-04-18T20:02:00.000\",\"dateUtc\":\"2018-04-19T00:02:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T19:25:00.000\",\"dateUtc\":\"2018-04-18T23:25:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"EI\",\"flightNumber\":\"5021\",\"relationship\":\"L\"},{\"fsCode\":\"EK\",\"flightNumber\":\"6704\",\"relationship\":\"L\"},{\"fsCode\":\"EY\",\"flightNumber\":\"8241\",\"relationship\":\"L\"},{\"fsCode\":\"LY\",\"flightNumber\":\"8606\",\"relationship\":\"L\"},{\"fsCode\":\"QR\",\"flightNumber\":\"3912\",\"relationship\":\"L\"}],\"flightDurations\":{\"scheduledBlockMinutes\":92,\"scheduledAirMinutes\":44,\"scheduledTaxiOutMinutes\":11,\"scheduledTaxiInMinutes\":37},\"airportResources\":{\"departureTerminal\":\"C\",\"departureGate\":\"C30\",\"arrivalTerminal\":\"5\",\"arrivalGate\":\"12\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"E90\",\"actualEquipmentIataCode\":\"E90\"}},{\"flightId\":956571579,\"carrierFsCode\":\"B6\",\"flightNumber\":\"6101\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T18:40:00.000\",\"dateUtc\":\"2018-04-18T22:40:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T19:40:00.000\",\"dateUtc\":\"2018-04-18T23:40:00.000Z\"},\"status\":\"S\",\"operationalTimes\":{\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T18:40:00.000\",\"dateUtc\":\"2018-04-18T22:40:00.000Z\"},\"estimatedGateDeparture\":{\"dateLocal\":\"2018-04-18T18:40:00.000\",\"dateUtc\":\"2018-04-18T22:40:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T18:50:00.000\",\"dateUtc\":\"2018-04-18T22:50:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T19:40:00.000\",\"dateUtc\":\"2018-04-18T23:40:00.000Z\"},\"estimatedGateArrival\":{\"dateLocal\":\"2018-04-18T19:40:00.000\",\"dateUtc\":\"2018-04-18T23:40:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T19:33:00.000\",\"dateUtc\":\"2018-04-18T23:33:00.000Z\"}},\"flightDurations\":{\"scheduledBlockMinutes\":60,\"scheduledAirMinutes\":43,\"scheduledTaxiOutMinutes\":10,\"scheduledTaxiInMinutes\":7},\"airportResources\":{\"departureTerminal\":\"C\",\"departureGate\":\"C32\",\"arrivalTerminal\":\"5\",\"arrivalGate\":\"7\"},\"flightEquipment\":{\"actualEquipmentIataCode\":\"32S\"}},{\"flightId\":956272469,\"carrierFsCode\":\"9E\",\"flightNumber\":\"3471\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T19:25:00.000\",\"dateUtc\":\"2018-04-18T23:25:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T20:54:00.000\",\"dateUtc\":\"2018-04-19T00:54:00.000Z\"},\"status\":\"S\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"FY\",\"restrictions\":\"\"},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T19:25:00.000\",\"dateUtc\":\"2018-04-18T23:25:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T20:54:00.000\",\"dateUtc\":\"2018-04-19T00:54:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T19:25:00.000\",\"dateUtc\":\"2018-04-18T23:25:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T19:32:00.000\",\"dateUtc\":\"2018-04-18T23:32:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T20:54:00.000\",\"dateUtc\":\"2018-04-19T00:54:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T20:15:00.000\",\"dateUtc\":\"2018-04-19T00:15:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"AF\",\"flightNumber\":\"8512\",\"relationship\":\"L\"},{\"fsCode\":\"AZ\",\"flightNumber\":\"5917\",\"relationship\":\"L\"},{\"fsCode\":\"KE\",\"flightNumber\":\"7310\",\"relationship\":\"L\"},{\"fsCode\":\"KL\",\"flightNumber\":\"6475\",\"relationship\":\"L\"},{\"fsCode\":\"MU\",\"flightNumber\":\"8866\",\"relationship\":\"L\"},{\"fsCode\":\"UX\",\"flightNumber\":\"3315\",\"relationship\":\"L\"},{\"fsCode\":\"VS\",\"flightNumber\":\"4654\",\"relationship\":\"L\"},{\"fsCode\":\"WS\",\"flightNumber\":\"6421\",\"relationship\":\"L\"},{\"fsCode\":\"DL\",\"flightNumber\":\"3471\",\"relationship\":\"S\"}],\"flightDurations\":{\"scheduledBlockMinutes\":89,\"scheduledAirMinutes\":43,\"scheduledTaxiOutMinutes\":7,\"scheduledTaxiInMinutes\":39},\"airportResources\":{\"departureTerminal\":\"A\",\"departureGate\":\"A1\",\"arrivalTerminal\":\"4\",\"arrivalGate\":\"B55\",\"baggage\":\"T4\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"CR9\",\"actualEquipmentIataCode\":\"CR9\",\"tailNumber\":\"N607LR\"}},{\"flightId\":956260701,\"carrierFsCode\":\"B6\",\"flightNumber\":\"317\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T20:54:00.000\",\"dateUtc\":\"2018-04-19T00:54:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T22:12:00.000\",\"dateUtc\":\"2018-04-19T02:12:00.000Z\"},\"status\":\"S\",\"schedule\":{\"flightType\":\"J\",\"serviceClasses\":\"RFJY\",\"restrictions\":\"\"},\"operationalTimes\":{\"publishedDeparture\":{\"dateLocal\":\"2018-04-18T20:54:00.000\",\"dateUtc\":\"2018-04-19T00:54:00.000Z\"},\"publishedArrival\":{\"dateLocal\":\"2018-04-18T22:12:00.000\",\"dateUtc\":\"2018-04-19T02:12:00.000Z\"},\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T20:54:00.000\",\"dateUtc\":\"2018-04-19T00:54:00.000Z\"},\"estimatedGateDeparture\":{\"dateLocal\":\"2018-04-18T20:54:00.000\",\"dateUtc\":\"2018-04-19T00:54:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T21:06:00.000\",\"dateUtc\":\"2018-04-19T01:06:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T22:12:00.000\",\"dateUtc\":\"2018-04-19T02:12:00.000Z\"},\"estimatedGateArrival\":{\"dateLocal\":\"2018-04-18T22:12:00.000\",\"dateUtc\":\"2018-04-19T02:12:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T21:50:00.000\",\"dateUtc\":\"2018-04-19T01:50:00.000Z\"}},\"codeshares\":[{\"fsCode\":\"EI\",\"flightNumber\":\"5013\",\"relationship\":\"L\"},{\"fsCode\":\"HA\",\"flightNumber\":\"2001\",\"relationship\":\"L\"},{\"fsCode\":\"TP\",\"flightNumber\":\"8001\",\"relationship\":\"L\"}],\"flightDurations\":{\"scheduledBlockMinutes\":78,\"scheduledAirMinutes\":44,\"scheduledTaxiOutMinutes\":12,\"scheduledTaxiInMinutes\":22},\"airportResources\":{\"departureTerminal\":\"C\",\"departureGate\":\"C14\",\"arrivalTerminal\":\"5\",\"arrivalGate\":\"8\"},\"flightEquipment\":{\"scheduledEquipmentIataCode\":\"E90\",\"actualEquipmentIataCode\":\"E90\"}},{\"flightId\":956574501,\"carrierFsCode\":\"B6\",\"flightNumber\":\"6118\",\"departureAirportFsCode\":\"BOS\",\"arrivalAirportFsCode\":\"JFK\",\"departureDate\":{\"dateLocal\":\"2018-04-18T21:00:00.000\",\"dateUtc\":\"2018-04-19T01:00:00.000Z\"},\"arrivalDate\":{\"dateLocal\":\"2018-04-18T22:00:00.000\",\"dateUtc\":\"2018-04-19T02:00:00.000Z\"},\"status\":\"S\",\"operationalTimes\":{\"scheduledGateDeparture\":{\"dateLocal\":\"2018-04-18T21:00:00.000\",\"dateUtc\":\"2018-04-19T01:00:00.000Z\"},\"estimatedGateDeparture\":{\"dateLocal\":\"2018-04-18T21:00:00.000\",\"dateUtc\":\"2018-04-19T01:00:00.000Z\"},\"flightPlanPlannedDeparture\":{\"dateLocal\":\"2018-04-18T21:16:00.000\",\"dateUtc\":\"2018-04-19T01:16:00.000Z\"},\"scheduledGateArrival\":{\"dateLocal\":\"2018-04-18T22:00:00.000\",\"dateUtc\":\"2018-04-19T02:00:00.000Z\"},\"estimatedGateArrival\":{\"dateLocal\":\"2018-04-18T22:00:00.000\",\"dateUtc\":\"2018-04-19T02:00:00.000Z\"},\"flightPlanPlannedArrival\":{\"dateLocal\":\"2018-04-18T21:59:00.000\",\"dateUtc\":\"2018-04-19T01:59:00.000Z\"}},\"flightDurations\":{\"scheduledBlockMinutes\":60,\"scheduledAirMinutes\":43,\"scheduledTaxiOutMinutes\":16,\"scheduledTaxiInMinutes\":1},\"airportResources\":{\"departureTerminal\":\"C\",\"arrivalTerminal\":\"5\",\"arrivalGate\":\"14\"},\"flightEquipment\":{\"actualEquipmentIataCode\":\"321\"}}]}"
    )
  end

end