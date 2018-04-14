defmodule OntimeWeb.AirlineController do
  use OntimeWeb, :controller

  alias Ontime.Aviation
  alias Ontime.Aviation.Airline

  action_fallback OntimeWeb.FallbackController

  def index(conn, _params) do
    airlines = Aviation.list_airlines()
    render(conn, "index.json", airlines: airlines)
  end

  def create(conn, %{"airline" => airline_params}) do
    with {:ok, %Airline{} = airline} <- Aviation.create_airline(airline_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", airline_path(conn, :show, airline))
      |> render("show.json", airline: airline)
    end
  end

  def show(conn, %{"id" => id}) do
    airline = Aviation.get_airline!(id)
    render(conn, "show.json", airline: airline)
  end

  def update(conn, %{"id" => id, "airline" => airline_params}) do
    airline = Aviation.get_airline!(id)

    with {:ok, %Airline{} = airline} <- Aviation.update_airline(airline, airline_params) do
      render(conn, "show.json", airline: airline)
    end
  end

  def delete(conn, %{"id" => id}) do
    airline = Aviation.get_airline!(id)
    with {:ok, %Airline{}} <- Aviation.delete_airline(airline) do
      send_resp(conn, :no_content, "")
    end
  end
end
