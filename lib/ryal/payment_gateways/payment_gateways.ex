defmodule Ryal.PaymentGateways do
  @callback create(atom, %{}, String.t() | nil) :: {:ok, %{}}
  @callback create(atom, %{}) :: {:ok, %{}}

  @callback update(atom, %{}, String.t() | nil) :: {:ok, %{}}
  @callback update(atom, %{}) :: {:ok, %{}}

  @callback delete(atom, %{}, String.t() | nil) :: {:ok, %{}}
  @callback delete(atom, %{}) :: {:ok, %{}}

  @optional_callbacks create: 2, update: 2, delete: 2
end
