defmodule FEx.APIs.Fixer do
  @callback rate(atom(), atom()) :: {:ok, any()}

  def rate(from, to), do: impl().rate(from, to)

  defp impl, do: Application.get_env(:fex, :fixer, __MODULE__.HTTPClient)
end
