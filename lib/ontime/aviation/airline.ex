defmodule Ontime.Aviation.Airline do
  use Ecto.Schema
  import Ecto.Changeset


  schema "airlines" do
    field :active, :string
    field :airline_id, :integer
    field :alias, :string
    field :callsign, :string
    field :country, :string
    field :iata, :string
    field :icao, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(airline, attrs) do
    airline
    |> cast(attrs, [:airline_id, :name, :alias, :iata, :icao, :callsign, :country, :active])
    |> validate_required([:airline_id, :name, :alias, :iata, :icao, :callsign, :country, :active])
  end
end
