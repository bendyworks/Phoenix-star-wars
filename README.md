# StarWars

## System level dependencies

There is a `.tool-version` file so if you have asdf installed you can just `asdf install` to meet the requirements. You will need the elixir and erlang plugins if you don't have them already. [ASDF](https://asdf-vm.com/) installation instructions are available.Otherwise read the `.tool-version` file and make sure your installed versions match.

## To start your Phoenix server

* Install dependencies with `mix deps.get`
* Have access to a Postgres database
* Set environment variables for Postgres access
  * POSTGRES_USER - default is `postgres`
  * POSTGRES_PASSWORD - default is `postgres`
  * POSTGRES_HOSTNAME - default is `localhost`
* Run `mix ecto.setup` to initialize the database
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Email

You can visit [the dev mailbox](http://localhost:4000/dev/mailbox) to see any emails your app has recently sent. This is handy for using the auth flow around resetting your password if auth is turned on.

# Deployment

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
