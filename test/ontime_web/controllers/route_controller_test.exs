defmodule OntimeWeb.RouteControllerTest do
  use OntimeWeb.ConnCase

  alias Ontime.Aviation
  alias Ontime.Aviation.Route

  @create_attrs %{airline: "some airline", airline_id: 42, codeshare: "some codeshare", dest_airport: "some dest_airport", dest_airport_id: 42, equipment: "some equipment", source_airport: "some source_airport", src_airport_id: 42, stops: "some stops"}
  @update_attrs %{airline: "some updated airline", airline_id: 43, codeshare: "some updated codeshare", dest_airport: "some updated dest_airport", dest_airport_id: 43, equipment: "some updated equipment", source_airport: "some updated source_airport", src_airport_id: 43, stops: "some updated stops"}
  @invalid_attrs %{airline: nil, airline_id: nil, codeshare: nil, dest_airport: nil, dest_airport_id: nil, equipment: nil, source_airport: nil, src_airport_id: nil, stops: nil}

  def fixture(:route) do
    {:ok, route} = Aviation.create_route(@create_attrs)
    route
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all routes", %{conn: conn} do
      conn = get conn, route_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create route" do
    test "renders route when data is valid", %{conn: conn} do
      conn = post conn, route_path(conn, :create), route: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, route_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "airline" => "some airline",
        "airline_id" => 42,
        "codeshare" => "some codeshare",
        "dest_airport" => "some dest_airport",
        "dest_airport_id" => 42,
        "equipment" => "some equipment",
        "source_airport" => "some source_airport",
        "src_airport_id" => 42,
        "stops" => "some stops"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, route_path(conn, :create), route: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update route" do
    setup [:create_route]

    test "renders route when data is valid", %{conn: conn, route: %Route{id: id} = route} do
      conn = put conn, route_path(conn, :update, route), route: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, route_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "airline" => "some updated airline",
        "airline_id" => 43,
        "codeshare" => "some updated codeshare",
        "dest_airport" => "some updated dest_airport",
        "dest_airport_id" => 43,
        "equipment" => "some updated equipment",
        "source_airport" => "some updated source_airport",
        "src_airport_id" => 43,
        "stops" => "some updated stops"}
    end

    test "renders errors when data is invalid", %{conn: conn, route: route} do
      conn = put conn, route_path(conn, :update, route), route: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete route" do
    setup [:create_route]

    test "deletes chosen route", %{conn: conn, route: route} do
      conn = delete conn, route_path(conn, :delete, route)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, route_path(conn, :show, route)
      end
    end
  end

  defp create_route(_) do
    route = fixture(:route)
    {:ok, route: route}
  end
end
