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

    @tag :fixer_api
    test "hits api" do
      assert false
    end
  end

  describe "symbols/0" do
    test "returns list of currency symbols" do
      expect(FEx.APIs.Fixer.Mock, :symbols, fn ->
        {:ok, ["GBP"]}
      end)

      assert FEx.APIs.Fixer.symbols() == {:ok, ["GBP"]}
    end
  end
end
