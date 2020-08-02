defmodule Ryal.Payments.Gateway do
  @moduledoc """
  For each gateway that an application is using, we have a profile or record of
  the `User`'s existence on that gateway. Think of it as a join table between a
  `User` and a payment provider.

  The behaviour for all of the payment gateways that we've setup are also
  contained inside of here. Please use this guy if you'd like to create your
  own. This way you don't make any mistakes and you get warnings if you update
  Ryal.
  """

  use Ryal, :schema

  alias Ryal.Config
  alias Ryal.Payments.MethodGateway

  schema "ryal_payment_gateways" do
    field :type, :string
    field :external_id, :string

    has_many :payment_method_gateways, MethodGateway

    belongs_to :user, Config.user_module()

    timestamps()
  end

  @required_fields ~w(type external_id user_id)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> assoc_constraint(:user)
    |> validate_required(@required_fields)
  end
end
