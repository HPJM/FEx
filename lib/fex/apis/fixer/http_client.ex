defmodule FEx.APIs.Fixer.HTTPClient do
  @behaviour FEx.APIs.Fixer

  @impl true
  def rate(from, to) do
    {:ok, %{from: from, to: to}}
  end
end
