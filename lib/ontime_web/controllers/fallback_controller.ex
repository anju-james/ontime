defmodule OntimeWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use OntimeWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(OntimeWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(OntimeWeb.ErrorView, :"404")
  end

  def call(conn, {:error, :no_content}) do
    conn |> put_status(:no_content) |> render(OntimeWeb.ErrorView,"notfound.json")
  end
end
