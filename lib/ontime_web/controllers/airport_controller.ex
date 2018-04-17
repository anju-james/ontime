defmodule OntimeWeb.AirportController do
  use OntimeWeb, :controller

  alias Ontime.Aviation
  alias Ontime.Aviation.Airport

  action_fallback OntimeWeb.FallbackController

  def index(conn, _params) do
    airports = Aviation.list_airports_in_us()
    render(conn, "index.json", airports: airports)
  end

  def create(conn, %{"airport" => airport_params}) do
    with {:ok, %Airport{} = airport} <- Aviation.create_airport(airport_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", airport_path(conn, :show, airport))
      |> render("show.json", airport: airport)
    end
  end

  def show(conn, %{"id" => id}) do
    airport = Aviation.get_airport!(id)
    render(conn, "show.json", airport: airport)
  end

  def update(conn, %{"id" => id, "airport" => airport_params}) do
    airport = Aviation.get_airport!(id)

    with {:ok, %Airport{} = airport} <- Aviation.update_airport(airport, airport_params) do
      render(conn, "show.json", airport: airport)
    end
  end

  def delete(conn, %{"id" => id}) do
    airport = Aviation.get_airport!(id)
    with {:ok, %Airport{}} <- Aviation.delete_airport(airport) do
      send_resp(conn, :no_content, "")
    end
  end
end
