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
      country: airport.country,
      iata: airport.iata,
      icao: airport.icao,
      latitude: airport.latitude,
      longitude: airport.longitude,
      altitude: airport.altitude,
      tz_offset: airport.tz_offset,
      dst: airport.dst,
      tz_name: airport.tz_name,
      type: airport.type,
      source: airport.source}
  end
end
