defmodule Ontime.Accounts.Chat do
  use Ecto.Schema
  import Ecto.Changeset


  schema "chats" do
    field :airport_iata, :string
    field :send_time, :naive_datetime
    field :text, :string
    field :user_name, :string

    timestamps()
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:airport_iata, :user_name, :text, :send_time])
    |> validate_required([:airport_iata, :user_name, :text, :send_time])
  end
end
