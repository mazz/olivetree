# OlivetreeApi

Deployment from:
https://www.shanesveller.com/blog/2018/11/13/kubernetes-native-phoenix-apps-part-2/

`docker-compose pull`
`docker-compose build --pull olivetree`
`docker-compose up --build -d postgres`
`docker-compose run --rm olivetree migrate`
`docker-compose run --rm olivetree seed`

Booting the application in Docker-Compose


`docker-compose up --build olivetree`

You can then browse the application by visiting http://localhost:4000 as normal, and should see the typical (production-style) log output in the shell session that’s running the above docker-compose command.

Note that this running container will not pick up any new file changes, perform live-reload behavior, and is generally not useful for development purposes. It’s primary value is ensuring that your release is properly configured via Distillery, and that your Dockerfile remains viable.
Cleaning Up

If you’d like to reset the database, or otherwise clean up after the Docker-Compose environment, you can use the down subcommand, optionally including a flag to clear the data volume as well. Without the flag, it will still remove the containers and Docker-specific network that was created for you.

`docker-compose down --volume`

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
