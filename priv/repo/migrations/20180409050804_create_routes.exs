defmodule Ontime.Repo.Migrations.CreateRoutes do
  use Ecto.Migration

  def change do
    create table(:routes) do
      add :airline, :string
      add :airline_id, :integer
      add :source_airport, :string
      add :src_airport_id, :integer
      add :dest_airport, :string
      add :dest_airport_id, :integer
      add :codeshare, :string
      add :stops, :string
      add :equipment, :string

      timestamps()
    end

  end
end
