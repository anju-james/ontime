defmodule OntimeWeb.SubscriptionControllerTest do
  use OntimeWeb.ConnCase

  alias Ontime.Tracking
  alias Ontime.Tracking.Subscription

  @create_attrs %{dest_iata: "some dest_iata", expired: true, flight_data: %{}, flight_time: "2010-04-17 14:00:00.000000Z", flightid: 42, srcia_iata: "some srcia_iata", userid: 42}
  @update_attrs %{dest_iata: "some updated dest_iata", expired: false, flight_data: %{}, flight_time: "2011-05-18 15:01:01.000000Z", flightid: 43, srcia_iata: "some updated srcia_iata", userid: 43}
  @invalid_attrs %{dest_iata: nil, expired: nil, flight_data: nil, flight_time: nil, flightid: nil, srcia_iata: nil, userid: nil}

  def fixture(:subscription) do
    {:ok, subscription} = Tracking.create_subscription(@create_attrs)
    subscription
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all subscriptions", %{conn: conn} do
      conn = get conn, subscription_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create subscription" do
    test "renders subscription when data is valid", %{conn: conn} do
      conn = post conn, subscription_path(conn, :create), subscription: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, subscription_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "dest_iata" => "some dest_iata",
        "expired" => true,
        "flight_data" => %{},
        "flight_time" => "2010-04-17 14:00:00.000000Z",
        "flightid" => 42,
        "srcia_iata" => "some srcia_iata",
        "userid" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, subscription_path(conn, :create), subscription: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update subscription" do
    setup [:create_subscription]

    test "renders subscription when data is valid", %{conn: conn, subscription: %Subscription{id: id} = subscription} do
      conn = put conn, subscription_path(conn, :update, subscription), subscription: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, subscription_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "dest_iata" => "some updated dest_iata",
        "expired" => false,
        "flight_data" => %{},
        "flight_time" => "2011-05-18 15:01:01.000000Z",
        "flightid" => 43,
        "srcia_iata" => "some updated srcia_iata",
        "userid" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, subscription: subscription} do
      conn = put conn, subscription_path(conn, :update, subscription), subscription: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete subscription" do
    setup [:create_subscription]

    test "deletes chosen subscription", %{conn: conn, subscription: subscription} do
      conn = delete conn, subscription_path(conn, :delete, subscription)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, subscription_path(conn, :show, subscription)
      end
    end
  end

  defp create_subscription(_) do
    subscription = fixture(:subscription)
    {:ok, subscription: subscription}
  end
end
