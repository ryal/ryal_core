defmodule Ryal.Config do
  @moduledoc false

  import Application, only: [get_env: 2, get_env: 3]

  alias Ryal.PaymentGateways
  alias Ryal.Payments.PaymentMethod

  @default_payment_gateway_modules %{
    bogus: PaymentGateways.Bogus,
    stripe: PaymentGateways.Stripe
  }

  @default_payment_methods %{
    credit_card: PaymentMethod.CreditCard
  }

  @doc "List all of the payment gateways configured for the application."
  @spec payment_gateways() :: list
  def payment_gateways, do: get_env(:ryal_core, :payment_gateways, [])

  @doc """
  This is the first payment gateway you listed for your application. We use the
  first gateway you specify as the primary gateway, then the second as the
  secondary, third is the tertiary, and so on... This way you know exactly how
  Ryal will fallback if your primary gateway isn't working.
  """
  @spec default_payment_gateway() :: tuple | nil
  def default_payment_gateway, do: List.first(payment_gateways())

  @doc "This loads up the map of data that you want specified by a data type."
  @spec payment_gateway(atom) :: String.t() | map
  def payment_gateway(type) do
    Enum.find(payment_gateways(), &(&1[:type] == type))
  end

  @spec payment_gateway_modules() :: %{}
  def payment_gateway_modules do
    Map.merge(
      @default_payment_gateway_modules,
      get_env(:ryal_core, :payment_gateway_modules, %{})
    )
  end

  @spec payment_gateway_module(atom) :: module | nil
  def payment_gateway_module(type), do: Map.get(payment_gateway_modules(), type)

  @spec fallback_gateways() :: list
  def fallback_gateways do
    case payment_gateways() do
      [] -> []
      [_default | fallbacks] -> fallbacks
    end
  end

  @spec payment_methods() :: map
  def payment_methods do
    Map.merge(@default_payment_methods, get_env(:ryal_core, :payment_methods, %{}))
  end

  @spec payment_method(atom) :: module
  def payment_method(type), do: Map.get(payment_methods(), type)

  @spec default_payment_methods() :: map
  def default_payment_methods, do: @default_payment_methods

  @spec repo() :: module
  def repo, do: get_env(:ryal_core, :repo)

  @spec user_module() :: module
  def user_module, do: get_env(:ryal_core, :user_module, Ryal.Accounts.User)

  @spec user_table() :: module
  def user_table, do: get_env(:ryal_core, :user_table, "ryal_users")
end
