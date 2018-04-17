defmodule OntimeWeb.FlightStatController do

  use OntimeWeb, :controller

  def get_status(conn, %{"src" => src, "dest" => dest}) do
    flight_data = get_flightdata(src)
    case flight_data do
      %{
        "error" => %{
          "text" => "No Record Found"
        }
      } ->
        conn
        |> put_status(:no_content)
        |> render(OntimeWeb.ErrorView, "notfound.json", %{message: "Search Yielded Not Resuls"})
      _ ->
        filtered_data = flight_data
                        |> Enum.filter(fn flight_info -> flight_info["arrival"]["iataCode"] == dest end)
        render(conn, "flightstatus.json", %{flightdata: filtered_data})
    end


  end

  '''
    def get_status(conn, %{"src" => src, "dest" => dest, "flightno" => flight_no}) do
      flight_data = get_flightdata(src)

      case flight_data do
            %{
              "error" => %{
                "text" => "No Record Found"
          }
        } ->
          conn
          |> put_status(:no_content)
          |> render(OntimeWeb.ErrorView, "notfound.json", %{message: "Search Yielded Not Resuls"})
        _ ->
        filtered_data = flight_data
                              |> Enum.filter(fn flight_info -> flight_info["arrival"]["iataCode"] == dest and flight_info["flight"][iataNumber] == flight_no end)
              render(conn, "flightstatus.json", %{flightdata: filtered_data})
          end
  '''



  def get_status_from_flightno(conn, %{"flightno" => flight_no}) do
    flightstatus = get_flight_status("aviationedge", flight_no)
    render(conn, "status.json", flightstatus: flightstatus)
  end

  defp get_flight_status("aviationedge", flight_no) do
    url = "http://aviation-edge.com/api/public/flights?key=#{get_aviationedge_api_key}&flight[iataNumber]=#{flight_no}"
    resp = HTTPoison.get!(url)
    Poison.decode!(resp.body)
  end


  defp get_airport_waitimes(src) do
    url = "https://www.ifly.com/api/v1/airport/#{src}/wait-times?date=2017-04-16&hr=08:00&rn=1523891031"
  end

  defp get_aviationedge_api_key, do: Application.get_env(:ontime, :aviationedge)[:api_key]

  def get_flightdata(src)do
    if true do
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
    else
      url = "http://aviation-edge.com/api/public/timetable?key=#{get_aviationedge_api_key}&iataCode=#{
        src
      }&type=departure"
      resp = HTTPoison.get!(url)
      Poison.decode!(resp.body)
    end
  end

end