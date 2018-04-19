defmodule OntimeWeb.Router do
  use OntimeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OntimeWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", OntimeWeb do
     pipe_through :api
     resources "/flightstat", FlightStatController
     resources "/airports", AirportController, except: [:new, :edit, :show, :update]
     resources "/airlines", AirlineController, except: [:new, :edit, :show, :update]
     resources "/routes", RouteController, except: [:new, :edit, :show, :update]
     resources "/users", UserController, except: [:new, :edit, :show, :update]
     resources "/subscriptions", SubscriptionController, except: [:new, :edit, :update]
     get "/flightstatus", FlightStatController, :get_status
  end

end
