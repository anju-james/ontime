defmodule Ontime.AviationAgent do

  alias Ontime.Aviation

  @moduledoc """
  An Agent used to store and retrieve airports.
  """

  @doc """
  Start agent as list of all airports.
  """
  def start_link do
    Agent.start_link(fn -> %{:airports => []} end, name: __MODULE__)
  end

  @doc """
  Retrieves the list of airports
  """
  def get_airports(), do:
    Agent.get(__MODULE__, &Map.get(&1, :airports))

  def put_airports(airports), do:
    Agent.get(__MODULE__, &Map.put(&1, :airports, airports))

end