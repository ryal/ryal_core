defmodule Ryal.Payment do
  @moduledoc """
  A payment that is made to a `Ryal.Order`.

  TODO: Payment documentation as this model becomes more fledged out.
  """

  use Ryal, :schema

  alias Ryal.NumberGenerator
  alias Ryal.Fulfillment.Order
  alias Ryal.Payments.Transition
  alias Ryal.PaymentGateways.PaymentMethodGateway

  schema "ryal_payments" do
    field :number, :string
    field :state, :string, default: "pending"
    field :amount, :decimal

    has_many :transitions, Transition

    belongs_to :order, Order
    belongs_to :payment_method_gateway, PaymentMethodGateway

    timestamps()
  end

  @required_fields ~w(amount order_id payment_method_gateway_id)a
  @optional_fields ~w(number)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> assoc_constraint(:order)
    |> assoc_constraint(:payment_method_gateway)
    |> generate_number
    |> validate_required(@required_fields)
    |> unique_constraint(:number)
  end

  def generate_number(changeset) do
    NumberGenerator.change_number(changeset, "P")
  end
end
