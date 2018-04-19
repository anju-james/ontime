defmodule OntimeWeb.SubscriptionController do
  use OntimeWeb, :controller

  alias Ontime.Tracking
  alias Ontime.Tracking.Subscription

  action_fallback OntimeWeb.FallbackController

  def index(conn, _params) do
    subscriptions = Tracking.list_subscriptions()
    render(conn, "index.json", subscriptions: subscriptions)
  end

  def create(conn, %{"subscription" => subscription_params, "token" => token}) do
    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, user_id} ->
        if user_id == subscription_params["userid"] do
          with {:ok, %Subscription{} = subscription} <- Tracking.create_subscription(subscription_params) do
            conn
            |> put_status(:created)
            |> put_resp_header("location", subscription_path(conn, :show, subscription))
            |> render("show.json", subscription: subscription)
          end
        else
          conn
          |> put_status(:unauthorized)
          |> render(
               OntimeWeb.ErrorView,
               "unauthorized.json",
               %{message: "Not authorized to perform the given action."}
             )
        end
    end
  end

  def delete(conn, %{"id" => id, "token" => token}) do
    case Phoenix.Token.verify(conn, "auth token", token, max_age: 86400) do
      {:ok, _user_id} ->
        subscription = Tracking.get_subscription!(id)
        with {:ok, %Subscription{}} <- Tracking.delete_subscription(subscription) do
          send_resp(conn, :no_content, "")
        end
    end
  end



  def show(conn, %{"id" => id}) do
    subscription = Tracking.get_subscription!(id)
    render(conn, "show.json", subscription: subscription)
  end

  def update(conn, %{"id" => id, "subscription" => subscription_params}) do
    subscription = Tracking.get_subscription!(id)

    with {:ok, %Subscription{} = subscription} <- Tracking.update_subscription(subscription, subscription_params) do
      render(conn, "show.json", subscription: subscription)
    end
  end
end
