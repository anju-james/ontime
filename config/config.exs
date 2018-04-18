# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ontime,
  ecto_repos: [Ontime.Repo]


# Configures the endpoint
config :ontime, OntimeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "CCBS+F/0rsBtWCFOROHR661keTThMD+kqlYc9hL1kdGxli2/sYr4zCXxrPj4yD2I",
  render_errors: [view: OntimeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ontime.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ontime, :aviationedge,
  api_key: System.get_env("AVIATIONEDGE_KEY")

config :ontime, :flightstats,
   app_id: System.get_env("FLIGHTSTATS_APP_ID"),
   app_key: System.get_env("FLIGHTSTATS_APP_KEY")

config :ontime, :nexmo,
       NEXMO_API_KEY: System.get_env("NEXMO_API_KEY"),
       NEXMO_API_SECRET: System.get_env("NEXMO_API_SECRET")


config :ontime, Ontime.Mailer,
       adapter: Swoosh.Adapters.Sendgrid,
       api_key: System.get_env("SENDGRID_API_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
