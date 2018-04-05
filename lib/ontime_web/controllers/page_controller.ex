defmodule OntimeWeb.PageController do
  use OntimeWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
