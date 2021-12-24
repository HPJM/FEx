defmodule FExTest do
  use ExUnit.Case
  doctest FEx

  test "greets the world" do
    assert FEx.hello() == :world
  end
end
