defmodule FEx.APIs.Fixer do
  @moduledoc """
  Represents the Fixer API: https://fixer.io/documentation
  """

  @behaviour FEx.APIs

  @callback rate(APIs.currency(), APIs.currency()) :: APIs.rate_response()
  @callback rates(APIs.currency()) :: APIs.rates_response()
  @callback rates(APIs.currency(), APIs.only()) :: APIs.rates_response()
  @callback symbols() :: APIs.currency_response()

  @implementation Application.compile_env!(:fex, :fixer)

  @doc """
  Determines rate of currency from `from` to `to`.
  """
  @impl true
  def rate(from, to), do: impl().rate(from, to)

  @doc """
  Determines rates from base currency `from`.
  """
  @impl true
  def rates(from), do: impl().rates(from)

  @doc """
  Determines rates from base currency `from` - filtered by `only`
  """
  @impl true
  def rates(from, only), do: impl().rates(from, only)

  @doc """
  Returns list of available currency symbols.
  """
  @impl true
  def symbols, do: impl().symbols

  defp impl, do: @implementation
end
