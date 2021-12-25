defmodule FEx.APIs.Fixer do
  @behaviour FEx.APIs

  @callback rate(atom(), atom()) :: {:ok, any()}

  @impl true
  def rate(from, to), do: impl().rate(from, to)

  defp impl, do: Application.get_env(:fex, :fixer, __MODULE__.HTTPClient)
end
