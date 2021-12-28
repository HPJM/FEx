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

  describe "rates/1" do
    test "returns rates from base currency" do
      expected = [%{from: :VND, to: :EUR, rate: 2.0}, %{from: :VND, to: :GBP, rate: 2.0}]

      expect(FEx.APIs.Fixer.Mock, :rates, fn :VND ->
        {:ok, expected}
      end)

      assert FEx.APIs.Fixer.rates(:VND) == {:ok, expected}
    end

    @tag :fixer_api
    test "returns correct data from api" do
      assert {:ok, rates} = FEx.APIs.Fixer.HTTPClient.rates(:VND)

      for rate <- rates do
        assert rate.from == :VND and is_number(rate.rate)
      end
    end
  end

  describe "rates/2" do
    test "returns rates from base currency, filtered by list" do
      expected = [%{from: :VND, to: :GBP, rate: 2.0}]

      expect(FEx.APIs.Fixer.Mock, :rates, fn :VND, [:GBP] ->
        {:ok, expected}
      end)

      assert FEx.APIs.Fixer.rates(:VND, [:GBP]) == {:ok, expected}
    end

    @tag :fixer_api
    test "returns correct data from api" do
      assert {:ok, [%{from: :VND, to: :GBP, rate: rate}]} =
               FEx.APIs.Fixer.HTTPClient.rates(:VND, [:GBP])

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
