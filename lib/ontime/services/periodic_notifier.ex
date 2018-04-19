defmodule Ontime.PeriodicNotifier do
  use GenServer

  alias Ontime.Tracking
  alias Ontime.FlightSearch
  alias Ontime.Tracking.Subscription
  alias Ontime.Accounts

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_notifier() # Schedule work to be performed on start
    {:ok, state}
  end

  def handle_info(:hourly, state) do
    # send out notifications
    send_notifications(:hourly);
    Process.send_after(self(), :hourly, 1 * 60 * 60 * 1000)
    {:noreply, state}
  end

  def handle_info(:daily, state) do
    # send out notifications
    send_notifications(:daily);
    # schedule next run
    Process.send_after(self(), :daily, 24 * 60 * 60 * 1000)
    {:noreply, state}
  end

  def send_notifications(type) do
    subscriptions = Tracking.list_all_active_subscriptions()
    next_day = Date.utc_today
               |> Date.add(1)
    today = Date.utc_today
    previous_day = Date.utc_today
                   |> Date.add(-1)
    hourly_scan = subscriptions
                  |> Enum.filter(
                       fn s -> (Date.compare(s.flight_time |> DateTime.to_date, today) == :eq)
                               || (Date.compare(s.flight_time |> DateTime.to_date,next_day) == :eq)
                               || (Date.compare(s.flight_time |> DateTime.to_date, previous_day) == :eq)
                       end)
    daily_scan = subscriptions |> Enum.filter(fn s -> !Enum.member?(hourly_scan, s) end)

    scan_subscriptions = if type == :hourly, do: hourly_scan, else: daily_scan

    scan_subscriptions |> Enum.each(fn s -> check_status_change(s) end)
  end

  defp check_status_change(subscription) do
    latest = FlightSearch.get_flightdata(subscription.flightid)
    case latest  do
      %{"flightStatus" => new} ->
        old = subscription.flight_data
        no_change = fn key, old, new -> Map.has_key?(old, key) == Map.has_key?(new, key) && old[key] == new[key] end
        fields = ["airportResources", "arrivalDate", "departureDate", "status"]
        has_no_changes = fields
                      |> Enum.all?(&no_change.(&1, old, new))
        if !has_no_changes do
          subscription_params = %{"flight_data" => new}
          if new["status"] != "A" || new["status"] != "S" do
            subscription_params = Map.merge(subscription_params,%{"expired" => true})
          end
          with {:ok, %Subscription{} = updated_subscription} <- Tracking.update_subscription(subscription, subscription_params) do
            user = Accounts.get_user!(updated_subscription.userid)
            Ontime.MessageService.send_message({:notify, :email, [user, updated_subscription]})
            Ontime.MessageService.send_message({:notify, :sms, [user, updated_subscription]})
          end
        end
    end
  end




  defp schedule_notifier() do
    Process.send_after(self(), :hourly, 1 * 60 * 60 * 1000)
    Process.send_after(self(), :daily, 24 * 60 * 60 * 1000)
  end

end