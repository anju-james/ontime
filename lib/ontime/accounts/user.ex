defmodule Ontime.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias OntimeWeb.Accounts.User


  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :phonenumber, :string
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :phonenumber])
    |> validate_password(:password)
    |> put_pass_hash()
    |> validate_required([:name, :email])
    |> validate_required([:phonenumber])
    |> validate_length(:name, max: 255)
    |> validate_length(:email, max: 255)
    |> validate_length(:phonenumber, min: 12, max: 12)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/, message: "Not a valid email address")

  end

  @doc """
    The password validation and hashset functions are based on Comeonin.Argon2 doc
  """
  defp put_pass_hash(
         %Ecto.Changeset{
           valid?: true,
           changes:
           %{
             password: password
           }
         } = changeset
       ) do
    change(changeset, Comeonin.Argon2.add_hash(password))
  end


  defp put_pass_hash(changeset), do: changeset

  defp valid_password?(password) when byte_size(password) > 7 do
    {:ok, password}
  end

  defp valid_password?(_), do: {:error, "The password is too short"}

  def validate_password(changeset, field, options \\ []) do
    validate_change(
      changeset,
      field,
      fn _, password ->
        case valid_password?(password) do
          {:ok, _} -> []
          {:error, msg} -> [{field, options[:message] || msg}]
        end
      end
    )
  end

end
