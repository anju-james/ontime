defmodule Ontime.Aviation.Route do
  use Ecto.Schema
  import Ecto.Changeset


  schema "routes" do
    field :airline, :string
    field :airline_id, :integer
    field :codeshare, :string
    field :dest_airport, :string
    field :dest_airport_id, :integer
    field :equipment, :string
    field :source_airport, :string
    field :src_airport_id, :integer
    field :stops, :string

    timestamps()
  end

  @doc false
  def changeset(route, attrs) do
    route
    |> cast(attrs, [:airline, :airline_id, :source_airport, :src_airport_id, :dest_airport, :dest_airport_id, :codeshare, :stops, :equipment])
    |> validate_required([:airline, :airline_id, :source_airport, :src_airport_id, :dest_airport, :dest_airport_id, :codeshare, :stops, :equipment])
  end
end
