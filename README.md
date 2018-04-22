# Ontime Web Application

## A Real Time Flight Status Checker and Airport Chat Forum
### Team 661: Anju James, Arcy Flores

## Design Choices for Checkers

You can visit the application [here](http://ontime.curiousmind.tech/)

=======================================================================
### Flight Status
Ontime is a flight status look up and flight alert web application that tracks the domestic flight statuses and details in the USA. Users can check for the status of their flights by entering the source airport and destination airport and the date they are travelling. The system picks up all the flights scheduled on the selected date from the source airport to the destination airport. For advanced filtering, the user can also enter the flight number which fetches only the relevant flight data of interest to the user. 

=======================================================================
### Flight Status Alert Subscriptions
The users are also given the option to subscribe for alerts for specific flights in our web application. On subscribing to alerts, an email and a text SMS message will be sent to the user’s email and phone number with the information regarding their flights. 

=======================================================================
### Airport Chat Forum
A real-time airport discussion/chat forum available for every airports in US where users can post questions or incidents related to airports or other relevant information that might impact travel. 


To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
