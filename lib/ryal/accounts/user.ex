defmodule Ryal.Accounts.User do
  use Ryal, :schema

  alias Ryal.{Fulfillment, PaymentGateways, Payments}

  schema "ryal_users" do
    field :email, :string

    has_many :orders, Fulfillment.Order
    has_many :payment_gateways, PaymentGateways.Customer
    has_many :payment_methods, Payments.PaymentMethod

    timestamps()
  end
end
