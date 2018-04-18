defmodule Ontime.EmailService do
  use GenServer

  alias Ontime.EmailService.UserEmail
  alias Ontime.Mailer

  #client
  def start_link do
    GenServer.start(__MODULE__, [], name: __MODULE__)
  end

  def send_email(message) do
    GenServer.cast(__MODULE__, message)
  end

  # server
  def handle_cast({:register, user}, state) do
    UserEmail.welcome(user) |> Mailer.deliver
    {:noreply, state}
  end


end