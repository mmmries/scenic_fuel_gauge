defmodule ScenicFuelGauge.MixProject do
  use Mix.Project

  @description """
  Scenic.FuelGauge - A component for displaying fuel level in a scenic project
  """

  def project do
    [
      app: :scenic_fuel_gauge,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: @description,
      docs: [
        main: "Scenic.FuelGauge",
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:scenic, "~> 0.10"},
      {:ex_doc, ">= 0.0.0", only: [:dev, :docs]}
    ]
  end
end
