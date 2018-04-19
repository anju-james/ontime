defmodule OntimeWeb.SubscriptionView do
  use OntimeWeb, :view
  alias OntimeWeb.SubscriptionView

  def render("index.json", %{subscriptions: subscriptions}) do
    %{data: render_many(subscriptions, SubscriptionView, "subscription.json")}
  end

  def render("show.json", %{subscription: subscription}) do
    %{data: render_one(subscription, SubscriptionView, "subscription.json")}
  end

  def render("subscription.json", %{subscription: subscription}) do
    %{id: subscription.id,
      flightid: subscription.flightid,
      userid: subscription.userid,
      srcia_iata: subscription.srcia_iata,
      dest_iata: subscription.dest_iata,
      flight_data: subscription.flight_data,
      flight_time: subscription.flight_time,
      expired: subscription.expired,
      airline_name: subscription.airline_name
    }
  end
end
