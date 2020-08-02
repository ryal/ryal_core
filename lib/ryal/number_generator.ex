defmodule Ryal.NumberGenerator do
  @moduledoc """
  A number generator for unique order numbers. It does not include lowercase
  letters.
  """

  @characters ~w(
    1 2 3 4 5 6 7 8 9
    A B C D E F G H J K L M N P Q R S T U V W X Y Z
  )

  @doc "Makes a sequence of characters. "
  def generate_sequence(count \\ 9) do
    @characters
    |> Enum.shuffle()
    |> Enum.take(count)
    |> Enum.join()
  end

  @doc """
  Given a changeset and a prefix, generates a sequence and applies it to a
  changeset's number field.
  """
  def change_number(changeset, prefix) do
    number = prefix <> generate_sequence()
    Ecto.Changeset.change(changeset, number: number)
  end
end
