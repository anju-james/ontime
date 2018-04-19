defmodule Ontime.Tracking.Subscription do
  use Ecto.Schema
  import Ecto.Changeset


  schema "subscriptions" do
    field :dest_iata, :string
    field :expired, :boolean, default: false
    field :flight_data, :map
    field :flight_time, :utc_datetime
    field :flightid, :integer
    field :srcia_iata, :string
    field :userid, :integer
    field :airline_name, :string

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:flightid, :userid, :srcia_iata, :dest_iata, :flight_data, :flight_time, :expired, :airline_name ])
    |> validate_required([:flightid, :userid, :srcia_iata, :dest_iata, :flight_data, :flight_time, :expired, :airline_name])
    |> unique_constraint(:flight_id, name: :user_flight_index)
  end
end
