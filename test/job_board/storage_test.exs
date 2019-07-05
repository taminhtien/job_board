defmodule JobBoard.StorageTest do
  use ExUnit.Case, async: true # run test concurrency
  alias JobBoard.Storage

  test "upserts the issue" do
    Storage.upsert(%{number: 1})
    Storage.upsert(%{number: 2})

    assert Storage.get(1) == %{number: 1}
  end
end
