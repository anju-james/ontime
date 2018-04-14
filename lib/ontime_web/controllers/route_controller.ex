defmodule OntimeWeb.RouteController do
  use OntimeWeb, :controller

  alias Ontime.Aviation
  alias Ontime.Aviation.Route

  action_fallback OntimeWeb.FallbackController

  def index(conn, _params) do
    routes = Aviation.list_routes()
    render(conn, "index.json", routes: routes)
  end

  def create(conn, %{"route" => route_params}) do
    with {:ok, %Route{} = route} <- Aviation.create_route(route_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", route_path(conn, :show, route))
      |> render("show.json", route: route)
    end
  end

  def show(conn, %{"id" => id}) do
    route = Aviation.get_route!(id)
    render(conn, "show.json", route: route)
  end

  def update(conn, %{"id" => id, "route" => route_params}) do
    route = Aviation.get_route!(id)

    with {:ok, %Route{} = route} <- Aviation.update_route(route, route_params) do
      render(conn, "show.json", route: route)
    end
  end

  def delete(conn, %{"id" => id}) do
    route = Aviation.get_route!(id)
    with {:ok, %Route{}} <- Aviation.delete_route(route) do
      send_resp(conn, :no_content, "")
    end
  end
end
