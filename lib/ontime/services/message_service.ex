defmodule Ontime.MessageService do
  use GenServer

  alias Ontime.MessageService.UserEmail
  alias Ontime.Mailer
  alias Ontime.MessageService.UserSMS
  alias Ontime.Tracking

  #client
  def start_link do
    GenServer.start(__MODULE__, [], name: __MODULE__)
  end

  def send_message(message) do
    GenServer.cast(__MODULE__, message)
  end

  # server
  def handle_cast({:email, :register, user}, state) do
    UserEmail.welcome(user)
    |> Mailer.deliver
    {:noreply, state}
  end

  def handle_cast({:subscribe, :email, payload}, state) do
    [user, subscription] = payload
    UserEmail.subscribe(user, subscription)
    |> Mailer.deliver
    {:noreply, state}
  end

  def handle_cast({:subscribe, :sms, payload}, state) do
    [user, subscription] = payload
    UserSMS.subscribe_sms(user, subscription)
    {:noreply, state}
  end

  def handle_cast({:notify, :email, payload}, state) do
    [user, subscription] = payload
    UserEmail.notify(user, subscription)
    |> Mailer.deliver
    {:noreply, state}
  end

  def handle_cast({:notify, :sms, payload}, state) do
    [user, subscription] = payload
    UserSMS.notify_sms(user, subscription)
    {:noreply, state}
  end


  def handle_cast({:sms, :register, user}, state) do
    UserSMS.send_sms(
      user.phonenumber,
      "Welcome Onboard. Thanks for signing up with Ontime. You add or change your alerts from the website https://ontime.curiousmind.tech"
    )
    {:noreply, state}
  end

end