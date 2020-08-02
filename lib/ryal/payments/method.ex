defmodule Ryal.Payments.Method do
  @moduledoc """
  A standard adapter to multiple payment methods.

  You can specify which payment you'd like to use via the `type` field and
  placing the data of a payment in the `data` field.

  The `data` field uses PostgreSQL's JSONB column to store the dynamic
  information. We use validations and whatnot at the application level to ensure
  the data is consistent. (Although, it would be nice is we could add
  constraints to PG later on.)

  ## Example

      iex> Ryal.Payments.Method.changeset(%Ryal.Payments.Method{}, %{
        type: "credit_card",
        user_id: 1,
        proxy: %{
          name: "Bobby Orr",
          number: "4242 4242 4242 4242",
          month: "03",
          year: "2048",
          cvc: "004"
        }
      })

      #Ecto.Changeset<action: nil,
       changes: %{data: #Ecto.Changeset<action: :insert,
          changes: %{cvc: "123", month: "03", name: "Bobby Orr",
            number: "4242 4242 4242 4242", year: "2048"}, errors: [],
          data: #Ryal.PaymentMethods.CreditCard<>, valid?: true>,
          type: "credit_card"},
       errors: [], data: #Ryal.Payments.Method<>, valid?: true>
  """

  use Ryal, :schema

  alias Ryal.Config

  schema "ryal_payment_methods" do
    field :type, :string

    embeds_one :proxy, Ryal.PaymentMethods.Proxy

    has_many :payment_method_gateways, MethodGateway

    belongs_to :user, Config.user_module()

    timestamps()
  end

  @required_fields ~w(type user_id)a

  @doc """
  You hand us some `data` and a `type` and we associate a payment method to a
  user.

  For an example on how to use this function, see the module description.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(set_module_type(params), @required_fields)
    |> assoc_constraint(:user)
    |> validate_required(@required_fields)
    |> cast_embed(:proxy, required: true)
  end

  # Loads up the module for the payment method type and then applies it to the
  # proxy column. This struct carries the module name and the data carried over.
  defp set_module_type(%{type: type} = params) do
    type = String.to_atom(type)
    proxy_data = Map.get(params, :proxy, %{})
    module_name = Config.payment_method(type)
    Map.put(params, :proxy, struct(module_name, proxy_data))
  end

  defp set_module_type(params), do: params
end
