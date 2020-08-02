# Ryal.Core

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ryal_core` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ryal_core, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ryal_core](https://hexdocs.pm/ryal_core).

## Schema

```
┌───────────────────┐    ┌─────────┐    ┌───────┐
│ PaymentTransition ╞────┤ Payment ╞────┤ Order ╞┐
└───────────────────┘    └────╥────┘    └───────┘│
                              │                  │
                              │                  │
 ┌───────────────┐   ┌────────┴─────────────┐    │
 │ PaymentMethod ├───╡ PaymentMethodGateway │    │
 └──────╥────────┘   └───────────╥──────────┘    │
        │                        │               │
        │                        │               │
    ┌───┴──┐         ┌───────────┴────────────┐  │
    │ User ├─────────╡ PaymentGatewayCustomer │  │
    └──┬───┘         └────────────────────────┘  │
       │                                         │
       └─────────────────────────────────────────┘
```
