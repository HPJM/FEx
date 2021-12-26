defmodule FEx do
  @moduledoc """
  Wrapper over FX APIs.
  """

  defmacro __using__(opts \\ []) do
    api_module = opts |> Keyword.fetch!(:api) |> Macro.expand_once(__ENV__)

    callbacks = FEx.APIs.behaviour_info(:callbacks)
    {:ok, docs} = get_docs(api_module)

    for {fun, arity} <- callbacks do
      {signature, doc} =
        Enum.find_value(docs, fn
          {{:function, ^fun, ^arity}, _, [signature], %{"en" => doc}, _} -> {signature, doc}
          _ -> false
        end)

      [_all, args] = Regex.run(~r|\(([^)]*)\)|, signature)

      args =
        args
        |> String.split(", ")
        |> Enum.reject(&(&1 == ""))
        |> Enum.map(&String.to_existing_atom/1)
        |> Enum.map(&{&1, [], __MODULE__})

      quote do
        @doc unquote(doc)
        def unquote(fun)(unquote_splicing(args)) do
          unquote(api_module).unquote(fun)(unquote_splicing(args))
        end
      end
    end
  end

  defp get_docs(api_module) do
    case Code.fetch_docs(api_module) do
      {_, _, _, _, _, _, docs} -> {:ok, docs}
      {:error, _} = error -> error
    end
  end
end
