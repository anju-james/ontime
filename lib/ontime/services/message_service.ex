defmodule Ontime.MessageService do
  use GenServer

  alias Ontime.MessageService.UserEmail
  alias Ontime.Mailer
  alias Ontime.MessageService.UserSMS

  #client
  def start_link do
    GenServer.start(__MODULE__, [], name: __MODULE__)
  end

  def send_message(message) do
    GenServer.cast(__MODULE__, message)
  end

  # server
  def handle_cast({:email, :register, user}, state) do
    UserEmail.welcome(user) |> Mailer.deliver
    {:noreply, state}
  end

  def handle_cast({:sms, :register, user}, state) do
    UserSMS.send_sms(user.phonenumber, "Welcome to Ontime alerts service. You can change your alert settings from the website https://ontime.curiousmind.tech")
    {:noreply, state}
  end


end