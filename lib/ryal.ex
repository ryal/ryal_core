defmodule Ryal do
  @moduledoc false

  def schema do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
