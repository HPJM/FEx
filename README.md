# FEx

Library to help with FX functionality. Intended to wrap various APIs, currently only Fixer is supported.

Can be used either directly, or by `use`ing `FEx`.

## Examples

With `use`

```elixir
defmodule MyModule do
  use FEx, api: FEx.APIs.Fixer

  def eur_usd do
    rate(:EUR, :USD)
  end
end
```

Direct

```elixir
defmodule MyModule do
  def eur_usd do
    FEx.APIs.Fixer.rate(:EUR, :USD)
  end
end
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `fex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:fex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/fex](https://hexdocs.pm/fex).

