defmodule Ontime.Repo.Migrations.CreateAirports do
  use Ecto.Migration

  def change do
    create table(:airports) do
      add :airport_id, :integer
      add :name, :string
      add :city, :string
      add :country, :string
      add :iata, :string
      add :icao, :string
      add :latitude, :float
      add :longitude, :float
      add :altitude, :integer
      add :tz_offset, :float
      add :dst, :string
      add :tz_name, :string
      add :type, :string
      add :source, :string

      timestamps()
    end

  end
end
