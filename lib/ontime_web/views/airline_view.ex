defmodule OntimeWeb.AirlineView do
  use OntimeWeb, :view
  alias OntimeWeb.AirlineView

  def render("index.json", %{airlines: airlines}) do
    %{data: render_many(airlines, AirlineView, "airline.json")}
  end

  def render("show.json", %{airline: airline}) do
    %{data: render_one(airline, AirlineView, "airline.json")}
  end

  def render("airline.json", %{airline: airline}) do
    %{id: airline.id,
      airline_id: airline.airline_id,
      name: airline.name,
      alias: airline.alias,
      iata: airline.iata,
      icao: airline.icao,
      callsign: airline.callsign,
      country: airline.country,
      active: airline.active}
  end
end
