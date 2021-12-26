defmodule FEx.APIs do
  @type currency :: atom()
  @type rate_pair :: %{from: currency(), to: currency(), rate: float()}
  @type symbol :: String.t()
  @type rate_response :: {:ok, rate_pair()} | {:error, any()}
  @type symbols_response :: {:ok, symbol()} | {:error, any()}

  @callback rate(currency(), currency()) :: rate_response()
  @callback symbols() :: symbols_response()
end
