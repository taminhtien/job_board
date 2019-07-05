defmodule JobBoard.WebRouterTest do
  use ExUnit.Case, async: true # run test concurrency
  use Plug.Test

  alias JobBoard.WebRouter

  @opts WebRouter.init([])

  test "/" do
    conn = conn(:get, "/")
    conn = WebRouter.call(conn, @opts)

    assert conn.status == 200
    assert conn.resp_body == "Hello World!"
  end

  test "/jobs" do
    JobBoard.Storage.upsert(%{number: 1, title: "A", body: "a"})
    JobBoard.Storage.upsert(%{number: 2, title: "B", body: "b"})

    conn = conn(:get, "/jobs")
    conn = WebRouter.call(conn, @opts)

    assert conn.status == 200
    assert conn.resp_body == Jason.encode!([%{number: 1, title: "A", body: "a"}, %{number: 2, title: "B", body: "b"}])
  end
end
