defmodule Ontime.AviationAgent do

  alias Ontime.Aviation

  @moduledoc """
  An Agent used to store and retrieve airports.
  """

  @doc """
  Start agent as list of all airports.
  """
  def start_link do
    airports = Aviation.list_airports_in_us()
    Agent.start_link(fn -> %{:airports => airports} end, name: __MODULE__)
  end

  @doc """
  Retrieves the list of airports
  """
  def get_airports(), do:
    Agent.get(__MODULE__, &Map.get(&1, :airports))

end