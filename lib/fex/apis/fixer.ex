defmodule FEx.APIs.Fixer do
  @moduledoc """
  Represents the Fixer API: https://fixer.io/documentation
  """

  @behaviour FEx.APIs

  @callback rate(APIs.currency(), APIs.currency()) :: APIs.rate_response()
  @callback symbols() :: APIs.currency_response()

  @doc """
  Determines rate of currency from `from` to `to`.
  """
  @impl true
  def rate(from, to), do: impl().rate(from, to)

  @doc """
  Returns list of available currency symbols.
  """
  @impl true
  def symbols, do: impl().symbols

  defp impl, do: Application.get_env(:fex, :fixer, __MODULE__.HTTPClient)
end
