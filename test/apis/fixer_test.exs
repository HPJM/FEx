defmodule FEx.APIs.FixerTest do
  use ExUnit.Case

  import Mox

  setup :verify_on_exit!

  describe "rate/2" do
    test "returns rate of given currencies" do
      expect(FEx.APIs.Fixer.Mock, :rate, fn :GBP, :EUR ->
        {:ok, %{from: :GBP, to: :EUR, rate: 2.0}}
      end)

      assert FEx.APIs.Fixer.rate(:GBP, :EUR) == {:ok, %{from: :GBP, to: :EUR, rate: 2.0}}
    end

    @tag :fixer_api
    test "returns correct data from api" do
      assert {:ok, rate} = FEx.APIs.Fixer.HTTPClient.rate(:GBP, :EUR)
      assert rate.from == :GBP
      assert rate.to == :EUR
      assert is_float(rate.rate)
    end
  end

  describe "symbols/0" do
    test "returns list of currency symbols" do
      expect(FEx.APIs.Fixer.Mock, :symbols, fn ->
        {:ok, ["GBP"]}
      end)

      assert FEx.APIs.Fixer.symbols() == {:ok, ["GBP"]}
    end

    @tag :fixer_api
    test "returns correct data from api" do
      assert {:ok, symbols} = FEx.APIs.Fixer.HTTPClient.symbols()
      assert Enum.all?(symbols, &is_binary/1)
    end
  end
end
