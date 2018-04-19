defmodule Ontime.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :flightid, :integer
      add :userid, :integer
      add :srcia_iata, :string
      add :dest_iata, :string
      add :flight_data, :map
      add :flight_time, :utc_datetime
      add :expired, :boolean, default: false, null: false

      timestamps()
    end

  end
end
