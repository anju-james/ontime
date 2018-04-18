defmodule OntimeWeb.FlightStatController do

  use OntimeWeb, :controller

  alias Ontime.FlightSearch


  def get_status(conn, %{"src" => src, "dest" => dest, "traveldate" => traveldate}) do
    flight_data = FlightSearch.get_flightdata(src, dest, traveldate)
    case flight_data do
      %{
        "error" => _
      } ->
        conn
        |> put_status(:no_content)
        |> render(OntimeWeb.ErrorView, "notfound.json", %{message: "Search Yielded Not Resuls"})
      _ ->
        render(conn, "flightstatus.json", %{flightdata: flight_data})
    end
  end

end