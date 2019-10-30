defmodule Scenic.FuelGaugeTest do
  use ExUnit.Case
  doctest Scenic.FuelGauge

  test "draws itself onto a graph" do
    graph = Scenic.Graph.build() |> Scenic.FuelGauge.draw(%{fuel: 0.5})
    assert %Scenic.Graph{} = graph
  end
end
