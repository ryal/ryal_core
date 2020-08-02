defmodule RyalTest do
  use ExUnit.Case
  doctest Ryal

  test "greets the world" do
    assert Ryal.hello() == :world
  end
end
