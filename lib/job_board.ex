defmodule JobBoard do
  def start(_type, _args) do
    children = [
      JobBoard.Fetcher,
      JobBoard.Storage,
      {Plug.Cowboy, scheme: :http, plug: JobBoard.WebRouter, options: [port: 8080]}
    ]

    options = [strategy: :one_for_one, name: JobBoard.Supervisor]

    Supervisor.start_link(children, options)

    # :observer.start
  end
end
