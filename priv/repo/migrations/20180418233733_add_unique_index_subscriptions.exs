defmodule Ontime.Repo.Migrations.AddUniqueIndexSubscriptions do
  use Ecto.Migration

  def change do
    create unique_index(:subscriptions, [:userid, :flightid], name: :user_flight_index)
  end
end
