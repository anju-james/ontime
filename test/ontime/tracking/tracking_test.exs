defmodule Ontime.TrackingTest do
  use Ontime.DataCase

  alias Ontime.Tracking

  describe "subscriptions" do
    alias Ontime.Tracking.Subscription

    @valid_attrs %{dest_iata: "some dest_iata", expired: true, flight_data: %{}, flight_time: "2010-04-17 14:00:00.000000Z", flightid: 42, srcia_iata: "some srcia_iata", userid: 42}
    @update_attrs %{dest_iata: "some updated dest_iata", expired: false, flight_data: %{}, flight_time: "2011-05-18 15:01:01.000000Z", flightid: 43, srcia_iata: "some updated srcia_iata", userid: 43}
    @invalid_attrs %{dest_iata: nil, expired: nil, flight_data: nil, flight_time: nil, flightid: nil, srcia_iata: nil, userid: nil}

    def subscription_fixture(attrs \\ %{}) do
      {:ok, subscription} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tracking.create_subscription()

      subscription
    end

    test "list_subscriptions/0 returns all subscriptions" do
      subscription = subscription_fixture()
      assert Tracking.list_subscriptions() == [subscription]
    end

    test "get_subscription!/1 returns the subscription with given id" do
      subscription = subscription_fixture()
      assert Tracking.get_subscription!(subscription.id) == subscription
    end

    test "create_subscription/1 with valid data creates a subscription" do
      assert {:ok, %Subscription{} = subscription} = Tracking.create_subscription(@valid_attrs)
      assert subscription.dest_iata == "some dest_iata"
      assert subscription.expired == true
      assert subscription.flight_data == %{}
      assert subscription.flight_time == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert subscription.flightid == 42
      assert subscription.srcia_iata == "some srcia_iata"
      assert subscription.userid == 42
    end

    test "create_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracking.create_subscription(@invalid_attrs)
    end

    test "update_subscription/2 with valid data updates the subscription" do
      subscription = subscription_fixture()
      assert {:ok, subscription} = Tracking.update_subscription(subscription, @update_attrs)
      assert %Subscription{} = subscription
      assert subscription.dest_iata == "some updated dest_iata"
      assert subscription.expired == false
      assert subscription.flight_data == %{}
      assert subscription.flight_time == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert subscription.flightid == 43
      assert subscription.srcia_iata == "some updated srcia_iata"
      assert subscription.userid == 43
    end

    test "update_subscription/2 with invalid data returns error changeset" do
      subscription = subscription_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracking.update_subscription(subscription, @invalid_attrs)
      assert subscription == Tracking.get_subscription!(subscription.id)
    end

    test "delete_subscription/1 deletes the subscription" do
      subscription = subscription_fixture()
      assert {:ok, %Subscription{}} = Tracking.delete_subscription(subscription)
      assert_raise Ecto.NoResultsError, fn -> Tracking.get_subscription!(subscription.id) end
    end

    test "change_subscription/1 returns a subscription changeset" do
      subscription = subscription_fixture()
      assert %Ecto.Changeset{} = Tracking.change_subscription(subscription)
    end
  end
end
