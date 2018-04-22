defmodule Ontime.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :airport_iata, :string
      add :user_name, :string
      add :text, :string
      add :send_time, :naive_datetime

      timestamps()
    end

  end
end
