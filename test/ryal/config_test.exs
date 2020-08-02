defmodule Ryal.ConfigTest do
  use ExUnit.Case

  alias Ryal.Config
  alias Ryal.Payments.PaymentMethod.CreditCard
  alias Ryal.PaymentGateways.{Bogus, Stripe}

  describe "payment_gateways/0" do
    test "will return list of payment gateways" do
      Application.put_env(:ryal_core, :payment_gateways, [1, 2, 3])
      assert Config.payment_gateways() == [1, 2, 3]
      Application.delete_env(:ryal_core, :payment_gateways)
    end

    test "will return an empty list if nil" do
      assert Config.payment_gateways() == []
    end
  end

  describe "default_payment_gateway/0" do
    test "will return the first payment gateway listed" do
      Application.put_env(:ryal_core, :payment_gateways, [1, 2])
      assert Config.default_payment_gateway() == 1
      Application.delete_env(:ryal_core, :payment_gateways)
    end

    test "will return nil if no payment gateways listed" do
      refute Config.default_payment_gateway()
    end
  end

  describe "payment_gateway/1" do
    test "will lookup payment gateway module" do
      Application.put_env(:ryal_core, :payment_gateways, [%{name: :foo, type: :bar}])
      assert Config.payment_gateway(:bar).name == :foo
      Application.delete_env(:ryal_core, :payment_gateways)
    end

    test "will return nil when none found" do
      refute Config.payment_gateway(:foo)
    end
  end

  describe "payment_gateway_modules/0" do
    test "will provide the default payment gateway modules" do
      assert Config.payment_gateway_modules() == %{bogus: Bogus, stripe: Stripe}
    end

    test "will provide additional payment gateway modules" do
      Application.put_env(:ryal_core, :payment_gateway_modules, %{foo: Bar})
      assert Config.payment_gateway_modules() == %{bogus: Bogus, foo: Bar, stripe: Stripe}
      Application.delete_env(:ryal_core, :payment_gateway_modules)
    end
  end

  describe "payment_gateway_module/1" do
    test "will lookup payment gateway module" do
      assert Config.payment_gateway_module(:stripe) == Stripe
    end

    test "will return nil when payment gateway module is not found" do
      refute Config.payment_gateway_module(:foo)
    end
  end

  describe "fallback_gateways/0" do
    test "will return the tail of payment gateways" do
      Application.put_env(:ryal_core, :payment_gateways, [1, 2])
      assert Config.fallback_gateways() == [2]
      Application.delete_env(:ryal_core, :payment_gateways)
    end

    test "will return an empty list if there is only a default" do
      Application.put_env(:ryal_core, :payment_gateways, [1])
      assert Config.fallback_gateways() == []
      Application.delete_env(:ryal_core, :payment_gateways)
    end

    test "will return an empty list if there are no payment gateways" do
      assert Config.fallback_gateways() == []
    end
  end

  describe "payment_methods/0" do
    test "will return the default payment methods" do
      assert Config.payment_methods() == %{credit_card: CreditCard}
    end

    test "will return additional payment methods" do
      Application.put_env(:ryal_core, :payment_methods, %{check: Check})

      assert Config.payment_methods() == %{
               credit_card: CreditCard,
               check: Check
             }

      Application.delete_env(:ryal_core, :payment_methods)
    end
  end

  describe "payment_method/1" do
    test "will lookup payment method" do
      assert Config.payment_method(:credit_card) == CreditCard
    end

    test "will return nil when payment method is not found" do
      refute Config.payment_method(:foo)
    end
  end

  describe "default_payment_methods/0" do
    test "will return a map of the default payment methods" do
      assert Config.default_payment_methods() == %{credit_card: CreditCard}
    end
  end

  describe "repo/0" do
    test "will return the configured repo" do
      Application.put_env(:ryal_core, :repo, MyApp.Repo)
      assert Config.repo() == MyApp.Repo
      Application.delete_env(:ryal_core, :repo)
    end

    test "will return nil if repo is not found" do
      refute Config.repo()
    end
  end

  describe "user_module/0" do
    test "will return the configured user module" do
      Application.put_env(:ryal_core, :user_module, MyApp.Accounts.User)
      assert Config.user_module() == MyApp.Accounts.User
      Application.delete_env(:ryal_core, :user_module)
    end

    test "will return default user module if none configured" do
      assert Config.user_module() == Ryal.Accounts.User
    end
  end

  describe "user_table/0" do
    test "will return the configured user table" do
      Application.put_env(:ryal_core, :user_table, "users")
      assert Config.user_table() == "users"
      Application.delete_env(:ryal_core, :user_table)
    end

    test "will return default user table if non configured" do
      assert Config.user_table() == "ryal_users"
    end
  end
end
