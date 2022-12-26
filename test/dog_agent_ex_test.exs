defmodule DogAgentExTest do
  use ExUnit.Case
  doctest DogAgentEx

  test "greets the world" do
    assert DogAgentEx.hello() == :world
  end
end
