defmodule Ontime.Repo.Migrations.CreateAirlines do
  use Ecto.Migration

  def change do
    create table(:airlines) do
      add :airline_id, :integer
      add :name, :string
      add :alias, :string
      add :iata, :string
      add :icao, :string
      add :callsign, :string
      add :country, :string
      add :active, :string

      timestamps()
    end

  end
end
