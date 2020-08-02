defmodule Ryal.Core.MixProject do
  use Mix.Project

  def project do
    [
      app: :ryal_core,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Ryal.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "< 3.4.5"},
      {:jason, "~> 1.2"},
      {:httpotion, "~> 3.1.0"}
    ]
  end
end
