defmodule FEx.APIs do
  @type currency :: atom()
  @type rate_pair :: %{from: currency(), to: currency(), rate: float()}
  @type symbol :: String.t()
  @type rate_response :: {:ok, rate_pair()} | {:error, any()}
  @type rates_response :: {:ok, list(rate_pair())} | {:error, any()}
  @type symbols_response :: {:ok, symbol()} | {:error, any()}
  @type only :: list(atom())

  @callback rate(currency(), currency()) :: rate_response()
  @callback rates(currency()) :: rates_response()
  @callback rates(currency(), only()) :: rates_response()
  @callback symbols() :: symbols_response()
end
