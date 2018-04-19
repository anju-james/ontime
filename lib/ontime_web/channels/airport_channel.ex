defmodule OntimeWeb.AirportChannel do
  use OntimeWeb, :channel
  alias OntimeWeb.Presence

  def join("room:"<>airportname, _message, socket) do
    send self(), :after_join
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns.user, %{
      online_at: :os.system_time(:milli_seconds)
    })
    push socket, "presence_state", Presence.list(socket)
    {:noreply, socket}
  end


end