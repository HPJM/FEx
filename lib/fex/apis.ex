defmodule FEx.APIs do
  @type currency :: atom()
  @callback rate(currency(), currency()) :: {:ok, any()} | {:error, any()}
end
