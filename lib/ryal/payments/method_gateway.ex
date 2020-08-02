defmodule Ryal.PaymentGateways.PaymentMethodGateway do
  @moduledoc """
  A join table between a `Ryal.PaymentGateway` and a `Ryal.PaymentMethod`, this
  model is responsible for connecting a payment to a user's payment method and
  billing it under the appropriate `Ryal.PaymentGateway`.
  """

  use Ryal, :schema

  alias Ryal.Payments.{Payment, PaymentMethod}
  alias Ryal.PaymentGateways.Customer

  schema "ryal_payment_method_gateways" do
    field :external_id, :string

    has_many :payments, Payment

    belongs_to :payment_gateway, Customer
    belongs_to :payment_method, PaymentMethod

    timestamps()
  end

  @required_fields ~w(external_id payment_method_id payment_gateway_id)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:payment_gateway)
    |> assoc_constraint(:payment_method)
  end
end
