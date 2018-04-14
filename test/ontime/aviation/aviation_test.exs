defmodule Ontime.AviationTest do
  use Ontime.DataCase

  alias Ontime.Aviation

  describe "airports" do
    alias Ontime.Aviation.Airport

    @valid_attrs %{airport_id: 42, altitude: 42, city: "some city", country: "some country", dst: "some dst", iata: "some iata", icao: "some icao", latitude: 120.5, longitude: 120.5, name: "some name", source: "some source", type: "some type", tz_name: "some tz_name", tz_offset: 120.5}
    @update_attrs %{airport_id: 43, altitude: 43, city: "some updated city", country: "some updated country", dst: "some updated dst", iata: "some updated iata", icao: "some updated icao", latitude: 456.7, longitude: 456.7, name: "some updated name", source: "some updated source", type: "some updated type", tz_name: "some updated tz_name", tz_offset: 456.7}
    @invalid_attrs %{airport_id: nil, altitude: nil, city: nil, country: nil, dst: nil, iata: nil, icao: nil, latitude: nil, longitude: nil, name: nil, source: nil, type: nil, tz_name: nil, tz_offset: nil}

    def airport_fixture(attrs \\ %{}) do
      {:ok, airport} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Aviation.create_airport()

      airport
    end

    test "list_airports/0 returns all airports" do
      airport = airport_fixture()
      assert Aviation.list_airports() == [airport]
    end

    test "get_airport!/1 returns the airport with given id" do
      airport = airport_fixture()
      assert Aviation.get_airport!(airport.id) == airport
    end

    test "create_airport/1 with valid data creates a airport" do
      assert {:ok, %Airport{} = airport} = Aviation.create_airport(@valid_attrs)
      assert airport.airport_id == 42
      assert airport.altitude == 42
      assert airport.city == "some city"
      assert airport.country == "some country"
      assert airport.dst == "some dst"
      assert airport.iata == "some iata"
      assert airport.icao == "some icao"
      assert airport.latitude == 120.5
      assert airport.longitude == 120.5
      assert airport.name == "some name"
      assert airport.source == "some source"
      assert airport.type == "some type"
      assert airport.tz_name == "some tz_name"
      assert airport.tz_offset == 120.5
    end

    test "create_airport/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Aviation.create_airport(@invalid_attrs)
    end

    test "update_airport/2 with valid data updates the airport" do
      airport = airport_fixture()
      assert {:ok, airport} = Aviation.update_airport(airport, @update_attrs)
      assert %Airport{} = airport
      assert airport.airport_id == 43
      assert airport.altitude == 43
      assert airport.city == "some updated city"
      assert airport.country == "some updated country"
      assert airport.dst == "some updated dst"
      assert airport.iata == "some updated iata"
      assert airport.icao == "some updated icao"
      assert airport.latitude == 456.7
      assert airport.longitude == 456.7
      assert airport.name == "some updated name"
      assert airport.source == "some updated source"
      assert airport.type == "some updated type"
      assert airport.tz_name == "some updated tz_name"
      assert airport.tz_offset == 456.7
    end

    test "update_airport/2 with invalid data returns error changeset" do
      airport = airport_fixture()
      assert {:error, %Ecto.Changeset{}} = Aviation.update_airport(airport, @invalid_attrs)
      assert airport == Aviation.get_airport!(airport.id)
    end

    test "delete_airport/1 deletes the airport" do
      airport = airport_fixture()
      assert {:ok, %Airport{}} = Aviation.delete_airport(airport)
      assert_raise Ecto.NoResultsError, fn -> Aviation.get_airport!(airport.id) end
    end

    test "change_airport/1 returns a airport changeset" do
      airport = airport_fixture()
      assert %Ecto.Changeset{} = Aviation.change_airport(airport)
    end
  end

  describe "airlines" do
    alias Ontime.Aviation.Airline

    @valid_attrs %{active: "some active", airline_id: 42, alias: "some alias", callsign: "some callsign", country: "some country", iata: "some iata", icao: "some icao", name: "some name"}
    @update_attrs %{active: "some updated active", airline_id: 43, alias: "some updated alias", callsign: "some updated callsign", country: "some updated country", iata: "some updated iata", icao: "some updated icao", name: "some updated name"}
    @invalid_attrs %{active: nil, airline_id: nil, alias: nil, callsign: nil, country: nil, iata: nil, icao: nil, name: nil}

    def airline_fixture(attrs \\ %{}) do
      {:ok, airline} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Aviation.create_airline()

      airline
    end

    test "list_airlines/0 returns all airlines" do
      airline = airline_fixture()
      assert Aviation.list_airlines() == [airline]
    end

    test "get_airline!/1 returns the airline with given id" do
      airline = airline_fixture()
      assert Aviation.get_airline!(airline.id) == airline
    end

    test "create_airline/1 with valid data creates a airline" do
      assert {:ok, %Airline{} = airline} = Aviation.create_airline(@valid_attrs)
      assert airline.active == "some active"
      assert airline.airline_id == 42
      assert airline.alias == "some alias"
      assert airline.callsign == "some callsign"
      assert airline.country == "some country"
      assert airline.iata == "some iata"
      assert airline.icao == "some icao"
      assert airline.name == "some name"
    end

    test "create_airline/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Aviation.create_airline(@invalid_attrs)
    end

    test "update_airline/2 with valid data updates the airline" do
      airline = airline_fixture()
      assert {:ok, airline} = Aviation.update_airline(airline, @update_attrs)
      assert %Airline{} = airline
      assert airline.active == "some updated active"
      assert airline.airline_id == 43
      assert airline.alias == "some updated alias"
      assert airline.callsign == "some updated callsign"
      assert airline.country == "some updated country"
      assert airline.iata == "some updated iata"
      assert airline.icao == "some updated icao"
      assert airline.name == "some updated name"
    end

    test "update_airline/2 with invalid data returns error changeset" do
      airline = airline_fixture()
      assert {:error, %Ecto.Changeset{}} = Aviation.update_airline(airline, @invalid_attrs)
      assert airline == Aviation.get_airline!(airline.id)
    end

    test "delete_airline/1 deletes the airline" do
      airline = airline_fixture()
      assert {:ok, %Airline{}} = Aviation.delete_airline(airline)
      assert_raise Ecto.NoResultsError, fn -> Aviation.get_airline!(airline.id) end
    end

    test "change_airline/1 returns a airline changeset" do
      airline = airline_fixture()
      assert %Ecto.Changeset{} = Aviation.change_airline(airline)
    end
  end

  describe "routes" do
    alias Ontime.Aviation.Route

    @valid_attrs %{airline: "some airline", airline_id: 42, codeshare: "some codeshare", dest_airport: "some dest_airport", dest_airport_id: 42, equipment: "some equipment", source_airport: "some source_airport", src_airport_id: 42, stops: "some stops"}
    @update_attrs %{airline: "some updated airline", airline_id: 43, codeshare: "some updated codeshare", dest_airport: "some updated dest_airport", dest_airport_id: 43, equipment: "some updated equipment", source_airport: "some updated source_airport", src_airport_id: 43, stops: "some updated stops"}
    @invalid_attrs %{airline: nil, airline_id: nil, codeshare: nil, dest_airport: nil, dest_airport_id: nil, equipment: nil, source_airport: nil, src_airport_id: nil, stops: nil}

    def route_fixture(attrs \\ %{}) do
      {:ok, route} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Aviation.create_route()

      route
    end

    test "list_routes/0 returns all routes" do
      route = route_fixture()
      assert Aviation.list_routes() == [route]
    end

    test "get_route!/1 returns the route with given id" do
      route = route_fixture()
      assert Aviation.get_route!(route.id) == route
    end

    test "create_route/1 with valid data creates a route" do
      assert {:ok, %Route{} = route} = Aviation.create_route(@valid_attrs)
      assert route.airline == "some airline"
      assert route.airline_id == 42
      assert route.codeshare == "some codeshare"
      assert route.dest_airport == "some dest_airport"
      assert route.dest_airport_id == 42
      assert route.equipment == "some equipment"
      assert route.source_airport == "some source_airport"
      assert route.src_airport_id == 42
      assert route.stops == "some stops"
    end

    test "create_route/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Aviation.create_route(@invalid_attrs)
    end

    test "update_route/2 with valid data updates the route" do
      route = route_fixture()
      assert {:ok, route} = Aviation.update_route(route, @update_attrs)
      assert %Route{} = route
      assert route.airline == "some updated airline"
      assert route.airline_id == 43
      assert route.codeshare == "some updated codeshare"
      assert route.dest_airport == "some updated dest_airport"
      assert route.dest_airport_id == 43
      assert route.equipment == "some updated equipment"
      assert route.source_airport == "some updated source_airport"
      assert route.src_airport_id == 43
      assert route.stops == "some updated stops"
    end

    test "update_route/2 with invalid data returns error changeset" do
      route = route_fixture()
      assert {:error, %Ecto.Changeset{}} = Aviation.update_route(route, @invalid_attrs)
      assert route == Aviation.get_route!(route.id)
    end

    test "delete_route/1 deletes the route" do
      route = route_fixture()
      assert {:ok, %Route{}} = Aviation.delete_route(route)
      assert_raise Ecto.NoResultsError, fn -> Aviation.get_route!(route.id) end
    end

    test "change_route/1 returns a route changeset" do
      route = route_fixture()
      assert %Ecto.Changeset{} = Aviation.change_route(route)
    end
  end
end
