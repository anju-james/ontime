defmodule Ontime.Aviation.Airport do
  use Ecto.Schema
  import Ecto.Changeset


  schema "airports" do
    field :airport_id, :integer
    field :altitude, :integer
    field :city, :string
    field :country, :string
    field :dst, :string
    field :iata, :string
    field :icao, :string
    field :latitude, :float
    field :longitude, :float
    field :name, :string
    field :source, :string
    field :type, :string
    field :tz_name, :string
    field :tz_offset, :float

    timestamps()
  end

  @doc false
  def changeset(airport, attrs) do
    airport
    |> cast(attrs, [:airport_id, :name, :city, :country, :iata, :icao, :latitude, :longitude, :altitude, :tz_offset, :dst, :tz_name, :type, :source])
    |> validate_required([:airport_id, :name, :city, :country, :iata, :icao, :latitude, :longitude, :altitude, :tz_offset, :dst, :tz_name, :type, :source])
  end
end
