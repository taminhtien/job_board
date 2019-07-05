defmodule JobBoard.WebRouter do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    conn
    |> put_resp_header("content-type", "text/plain")
    |> send_resp(200, "Hello World!")
  end

  get "/jobs" do
    list = JobBoard.Storage.list()

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Jason.encode!(list))
  end

  match _ do
    conn
    |> put_resp_header("content-type", "text/plain")
    |> send_resp(404, "Not Found")
  end
end
