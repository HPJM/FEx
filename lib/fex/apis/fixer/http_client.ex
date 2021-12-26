defmodule FEx.APIs.Fixer.HTTPClient do
  use HTTPoison.Base
  require Logger

  @endpoint "https://data.fixer.io/api"

  @behaviour FEx.APIs.Fixer

  @impl true
  def process_url(url) do
    @endpoint <> url
  end

  @impl true
  def rate(from, to) do
    with {:ok, response} <-
           "/latest"
           |> get([], params: [access_key: System.get_env("API_KEY"), base: from, symbols: to])
           |> maybe_decode() do
      format(:rate, from, to, response)
    end
  end

  @impl true
  def symbols do
    with {:ok, response} <-
           "/symbols"
           |> get([], params: [access_key: System.get_env("API_KEY")])
           |> maybe_decode() do
      handle_symbols(response)
    end
  end

  defp handle_symbols(%{body: %{"symbols" => symbols}}) do
    {:ok, symbols |> Map.keys() |> Enum.sort()}
  end

  defp handle_symbols(response) do
    {:error, {:invalid_data, response}}
  end

  defp format(:rate, from, to, %{body: %{"rates" => rates}}) do
    {:ok, %{from: from, to: to, rate: rates["#{to}"]}}
  end

  defp format(:rate, _from, _to, response) do
    {:error, {:invalid_data, response}}
  end

  defp maybe_decode({status, response = %{body: body}}) do
    maybe_parsed =
      body
      |> Jason.decode()
      |> case do
        {:ok, parsed} ->
          %{response | body: parsed}

        {:error, error} ->
          Logger.error("Couldn't parse response", api: :fixer, error: inspect(error))
          response
      end

    {status, maybe_parsed}
  end
end
