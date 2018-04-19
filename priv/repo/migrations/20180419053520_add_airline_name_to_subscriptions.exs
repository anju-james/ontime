defmodule Ontime.Repo.Migrations.AddAirlineNameToSubscriptions do
  use Ecto.Migration

  def change do
    alter table(:subscriptions) do
      add :airline_name, :string
    end
  end
end
