defmodule OntimeWeb.UserController do
  use OntimeWeb, :controller
  use Phoenix.Controller
  alias Ontime.Accounts
  alias Ontime.Accounts.User

  action_fallback OntimeWeb.FallbackController


  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do

      Ontime.EmailService.send_email({:register, user})

      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_and_auth_user(email, password) do
      {:ok, %User{} = user} ->
        token = Phoenix.Token.sign(conn, "auth token", user.id)
        conn
        |> put_status(:created)
        |> render("token.json", user: user, token: token)
      {:error, _message} ->
        conn
        |> put_status(:unauthorized)
        |> render(
             OntimeWeb.ErrorView,
             "unauthorized.json",
             %{message: "Login failed. Invalid credentials."}
           )
    end
  end


end
