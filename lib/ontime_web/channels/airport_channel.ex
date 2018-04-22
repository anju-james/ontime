defmodule OntimeWeb.AirportChannel do
  use OntimeWeb, :channel
  alias OntimeWeb.Presence
  alias Ontime.Accounts
  alias Ontime.Accounts.Chat
  def join("room:"<>airportname, _message, socket) do
    send self(), :after_join
    send self(), {:publish_initial_data, airportname}
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns[:user]["id"], %{
      online_at: :os.system_time(:milli_seconds)
    })
    push socket, "presence_state", Presence.list(socket)    
    {:noreply, socket}
  end

  def handle_info({:publish_initial_data, airportname}, socket) do
    IO.puts "loading initial data"
    last_chats = Accounts.last_n_chat_messages(airportname, 10)
    chats_map = last_chats |> Enum.map(fn chat -> chat |> Map.from_struct |> Map.delete(:__meta__) end)
    push socket, "last_msgs",  %{body: chats_map}
    {:noreply, socket}
  end

  def handle_in("new_msg", %{"body" => %{"airport_iata" => airport_iata, "text" => text}}, socket) do
    attrs = %{"airport_iata" => airport_iata, "user_name" => socket.assigns[:user]["name"], 
    "text" => text, "send_time" => DateTime.utc_now |> DateTime.to_naive}
    case Accounts.create_chat(attrs) do
      {:ok, %Chat{} = chat} -> 
        chat_map = chat |> Map.from_struct |> Map.delete(:__meta__)
        broadcast! socket, "new_msg", %{body: chat_map}      
    end
    {:noreply, socket}
  end

end