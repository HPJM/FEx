defmodule FEx.APIs.FixerTest do
  use ExUnit.Case

  import Mox

  setup :verify_on_exit!

  describe "rate/2" do
    test "returns rate of given currencies" do
      expected = {:GBP, :EUR, 2.0}

      expect(FEx.APIs.Fixer.Mock, :rate, fn :GBP, :EUR ->
        {:ok, expected}
      end)

      assert FEx.APIs.Fixer.rate(:GBP, :EUR) == {:ok, expected}
    end

    @tag :fixer_api
    test "returns correct data from api" do
      assert {:ok, {:GBP, :EUR, rate}} = FEx.APIs.Fixer.HTTPClient.rate(:GBP, :EUR)
      assert is_number(rate)
    end
  end

  describe "rates/1" do
    test "returns rates from base currency" do
      expected = {:VND, [EUR: 2.0, GBP: 2.0]}

      expect(FEx.APIs.Fixer.Mock, :rates, fn :VND ->
        {:ok, expected}
      end)

      assert FEx.APIs.Fixer.rates(:VND) == {:ok, expected}
    end

    @tag :fixer_api
    test "returns correct data from api" do
      assert {:ok, {:VND, rates}} = FEx.APIs.Fixer.HTTPClient.rates(:VND)

      for {_to, rate} <- rates do
        assert is_number(rate)
      end
    end
  end

  describe "rates/2" do
    test "returns rates from base currency, filtered by list" do
      expected = {:VND, [GBP: 2.0]}

      expect(FEx.APIs.Fixer.Mock, :rates, fn :VND, [:GBP] ->
        {:ok, expected}
      end)

      assert FEx.APIs.Fixer.rates(:VND, [:GBP]) == {:ok, expected}
    end

    @tag :fixer_api
    test "returns correct data from api" do
      assert {:ok, {:VND, [GBP: rate]}} = FEx.APIs.Fixer.HTTPClient.rates(:VND, [:GBP])

      assert is_number(rate)
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
