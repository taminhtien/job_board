defmodule JobBoardTest do
  use ExUnit.Case
  doctest JobBoard

  test "greets the world" do
    assert JobBoard.hello() == :world
  end
end
