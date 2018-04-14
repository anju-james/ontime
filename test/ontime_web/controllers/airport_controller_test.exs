defmodule OntimeWeb.AirportControllerTest do
  use OntimeWeb.ConnCase

  alias Ontime.Aviation
  alias Ontime.Aviation.Airport

  @create_attrs %{airport_id: 42, altitude: 42, city: "some city", country: "some country", dst: "some dst", iata: "some iata", icao: "some icao", latitude: 120.5, longitude: 120.5, name: "some name", source: "some source", type: "some type", tz_name: "some tz_name", tz_offset: 120.5}
  @update_attrs %{airport_id: 43, altitude: 43, city: "some updated city", country: "some updated country", dst: "some updated dst", iata: "some updated iata", icao: "some updated icao", latitude: 456.7, longitude: 456.7, name: "some updated name", source: "some updated source", type: "some updated type", tz_name: "some updated tz_name", tz_offset: 456.7}
  @invalid_attrs %{airport_id: nil, altitude: nil, city: nil, country: nil, dst: nil, iata: nil, icao: nil, latitude: nil, longitude: nil, name: nil, source: nil, type: nil, tz_name: nil, tz_offset: nil}

  def fixture(:airport) do
    {:ok, airport} = Aviation.create_airport(@create_attrs)
    airport
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all airports", %{conn: conn} do
      conn = get conn, airport_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create airport" do
    test "renders airport when data is valid", %{conn: conn} do
      conn = post conn, airport_path(conn, :create), airport: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, airport_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "airport_id" => 42,
        "altitude" => 42,
        "city" => "some city",
        "country" => "some country",
        "dst" => "some dst",
        "iata" => "some iata",
        "icao" => "some icao",
        "latitude" => 120.5,
        "longitude" => 120.5,
        "name" => "some name",
        "source" => "some source",
        "type" => "some type",
        "tz_name" => "some tz_name",
        "tz_offset" => 120.5}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, airport_path(conn, :create), airport: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update airport" do
    setup [:create_airport]

    test "renders airport when data is valid", %{conn: conn, airport: %Airport{id: id} = airport} do
      conn = put conn, airport_path(conn, :update, airport), airport: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, airport_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "airport_id" => 43,
        "altitude" => 43,
        "city" => "some updated city",
        "country" => "some updated country",
        "dst" => "some updated dst",
        "iata" => "some updated iata",
        "icao" => "some updated icao",
        "latitude" => 456.7,
        "longitude" => 456.7,
        "name" => "some updated name",
        "source" => "some updated source",
        "type" => "some updated type",
        "tz_name" => "some updated tz_name",
        "tz_offset" => 456.7}
    end

    test "renders errors when data is invalid", %{conn: conn, airport: airport} do
      conn = put conn, airport_path(conn, :update, airport), airport: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete airport" do
    setup [:create_airport]

    test "deletes chosen airport", %{conn: conn, airport: airport} do
      conn = delete conn, airport_path(conn, :delete, airport)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, airport_path(conn, :show, airport)
      end
    end
  end

  defp create_airport(_) do
    airport = fixture(:airport)
    {:ok, airport: airport}
  end
end
