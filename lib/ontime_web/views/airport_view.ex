defmodule OntimeWeb.AirportView do
  use OntimeWeb, :view
  alias OntimeWeb.AirportView

  def render("index.json", %{airports: airports}) do
    %{data: render_many(airports, AirportView, "airport.json")}
  end

  def render("show.json", %{airport: airport}) do
    %{data: render_one(airport, AirportView, "airport.json")}
  end

  def render("airport.json", %{airport: airport}) do
    %{id: airport.id,
      airport_id: airport.airport_id,
      name: airport.name,
      city: airport.city,
      iata: airport.iata,
      icao: airport.icao,
      }
  end
end
