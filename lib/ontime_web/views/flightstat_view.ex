defmodule OntimeWeb.FlightStatView do
  use OntimeWeb, :view
  alias OntimeWeb.FlightStatView

  def render("status.json", %{flightstatus: status}) do
    %{data: status}
  end

  def render("flightstatus.json", %{flightdata: flightdata}) do
    %{data: flightdata}
  end


end
