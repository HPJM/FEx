defmodule FEx.APIs.FixerTest do
  use ExUnit.Case

  import Mox

  setup :verify_on_exit!

  describe "rate/2" do
    test "returns rate of given currencies" do
      expect(FEx.APIs.Fixer.Mock, :rate, fn :GBP, :EUR ->
        {:ok, %{from: :GBP, to: :EUR}}
      end)

      assert FEx.APIs.Fixer.rate(:GBP, :EUR) == {:ok, %{from: :GBP, to: :EUR}}
    end

    @moduletag :fixer_api
    test "hits api" do
      assert false
    end
  end
end
