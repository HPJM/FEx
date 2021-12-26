defmodule FEx.APIs do
  @type currency :: atom()
  @callback rate(currency(), currency()) :: {:ok, any()} | {:error, any()}
  @callback symbols() :: {:ok, list(String.t())} | {:error, any()}
end
