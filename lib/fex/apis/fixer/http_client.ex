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
           |> get([], params: make_params(base: from, symbols: to))
           |> maybe_decode() do
      handle_rate_response(from, to, response)
    end
  end

  @impl true
  def rates(from) do
    with {:ok, response} <-
           "/latest"
           |> get([], params: make_params(base: from))
           |> maybe_decode() do
      handle_rates_response(from, response)
    end
  end

  @impl true
  def symbols do
    with {:ok, response} <-
           "/symbols"
           |> get([], params: make_params())
           |> maybe_decode() do
      handle_symbols_response(response)
    end
  end

  defp handle_symbols_response(%{body: %{"symbols" => symbols}}) do
    {:ok, symbols |> Map.keys() |> Enum.sort()}
  end

  defp handle_symbols_response(response) do
    {:error, {:invalid_data, response}}
  end

  defp handle_rate_response(from, to, %{body: %{"rates" => rates}}) do
    {:ok, %{from: from, to: to, rate: rates["#{to}"]}}
  end

  defp handle_rate_response(_from, _to, response) do
    {:error, {:invalid_data, response}}
  end

  defp handle_rates_response(from, %{body: %{"rates" => rates}}) do
    # TODO: allowlist for currencies
    rates_list = for {to, rate} <- rates, do: %{from: from, to: String.to_atom(to), rate: rate}
    {:ok, rates_list}
  end

  defp handle_rates_response(_from, response) do
    {:error, {:invalid_data, response}}
  end

  defp make_params(params \\ []) do
    Keyword.put(params, :access_key, System.get_env("API_KEY"))
  end

  defp decodable?(headers) do
    Enum.find_value(headers, fn
      {"content-type", content_type} -> String.starts_with?(content_type, "application/json")
      _ -> false
    end)
  end

  defp maybe_decode({status, response = %{body: body, headers: headers}}) do
    maybe_parsed =
      with true <- decodable?(headers), {:ok, parsed} <- Jason.decode(body) do
        %{response | body: parsed}
      else
        false ->
          body

        {:error, reason} ->
          Logger.error("Could not parse body", body: body, reason: inspect(reason))
          body
      end

    {status, maybe_parsed}
  end
end
