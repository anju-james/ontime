use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :ontime, OntimeWeb.Endpoint,
  secret_key_base: "k3HEokPHkCUkYY2FzOwxpq6Z6LlnaZGtQE+bvqLNpEf9AXxk5gy7IDtFWMftZtEq"

# Configure your database
config :ontime, Ontime.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "ontime_prod",
  pool_size: 15
