defmodule FExTest do
  use ExUnit.Case
  doctest FEx

  import Mox

  setup :verify_on_exit!

  defmodule ExampleUsing do
    use FEx, api: FEx.APIs.Fixer
  end

  describe "use'ing module injects functions into caller which defer to given api" do
    test "with example module" do
      expected = %{from: :GBP, rate: 1.0, to: :USD}
      expect(FEx.APIs.Fixer.Mock, :rate, fn :GBP, :USD -> expected end)

      assert ExampleUsing.rate(:GBP, :USD) == expected
    end
  end
end
