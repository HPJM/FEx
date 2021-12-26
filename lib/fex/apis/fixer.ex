defmodule FEx.APIs.Fixer do
  @behaviour FEx.APIs

  @callback rate(atom(), atom()) :: {:ok, any()}
  @callback symbols() :: {:ok, list(String.t())} | {:error, any()}

  @impl true
  def rate(from, to), do: impl().rate(from, to)

  @impl true
  def symbols, do: impl().symbols

  defp impl, do: Application.get_env(:fex, :fixer, __MODULE__.HTTPClient)
end
