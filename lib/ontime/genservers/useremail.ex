defmodule Ontime.EmailService.UserEmail do
  import Swoosh.Email

  def welcome(user) do
    new()
    |> to({user.name, user.email})
    |> from({"Ontime", "ontime@curiosumind.tech"})
    |> subject("Flight Status Alert!")
    |> html_body("<h1>Hello #{user.name}</h1>")
    |> text_body("Hello #{user.name}\n")
  end
end
