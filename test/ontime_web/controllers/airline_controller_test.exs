defmodule OntimeWeb.AirlineControllerTest do
  use OntimeWeb.ConnCase

  alias Ontime.Aviation
  alias Ontime.Aviation.Airline

  @create_attrs %{active: "some active", airline_id: 42, alias: "some alias", callsign: "some callsign", country: "some country", iata: "some iata", icao: "some icao", name: "some name"}
  @update_attrs %{active: "some updated active", airline_id: 43, alias: "some updated alias", callsign: "some updated callsign", country: "some updated country", iata: "some updated iata", icao: "some updated icao", name: "some updated name"}
  @invalid_attrs %{active: nil, airline_id: nil, alias: nil, callsign: nil, country: nil, iata: nil, icao: nil, name: nil}

  def fixture(:airline) do
    {:ok, airline} = Aviation.create_airline(@create_attrs)
    airline
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all airlines", %{conn: conn} do
      conn = get conn, airline_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create airline" do
    test "renders airline when data is valid", %{conn: conn} do
      conn = post conn, airline_path(conn, :create), airline: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, airline_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "active" => "some active",
        "airline_id" => 42,
        "alias" => "some alias",
        "callsign" => "some callsign",
        "country" => "some country",
        "iata" => "some iata",
        "icao" => "some icao",
        "name" => "some name"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, airline_path(conn, :create), airline: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update airline" do
    setup [:create_airline]

    test "renders airline when data is valid", %{conn: conn, airline: %Airline{id: id} = airline} do
      conn = put conn, airline_path(conn, :update, airline), airline: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, airline_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "active" => "some updated active",
        "airline_id" => 43,
        "alias" => "some updated alias",
        "callsign" => "some updated callsign",
        "country" => "some updated country",
        "iata" => "some updated iata",
        "icao" => "some updated icao",
        "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, airline: airline} do
      conn = put conn, airline_path(conn, :update, airline), airline: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete airline" do
    setup [:create_airline]

    test "deletes chosen airline", %{conn: conn, airline: airline} do
      conn = delete conn, airline_path(conn, :delete, airline)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, airline_path(conn, :show, airline)
      end
    end
  end

  defp create_airline(_) do
    airline = fixture(:airline)
    {:ok, airline: airline}
  end
end
