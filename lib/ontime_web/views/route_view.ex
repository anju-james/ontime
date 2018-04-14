defmodule OntimeWeb.RouteView do
  use OntimeWeb, :view
  alias OntimeWeb.RouteView

  def render("index.json", %{routes: routes}) do
    %{data: render_many(routes, RouteView, "route.json")}
  end

  def render("show.json", %{route: route}) do
    %{data: render_one(route, RouteView, "route.json")}
  end

  def render("route.json", %{route: route}) do
    %{id: route.id,
      airline: route.airline,
      airline_id: route.airline_id,
      source_airport: route.source_airport,
      src_airport_id: route.src_airport_id,
      dest_airport: route.dest_airport,
      dest_airport_id: route.dest_airport_id,
      codeshare: route.codeshare,
      stops: route.stops,
      equipment: route.equipment}
  end
end
