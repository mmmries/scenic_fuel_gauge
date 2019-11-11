defmodule Scenic.FuelGauge.Components do
  alias Scenic.Graph
  alias Scenic.Primitive
  alias Scenic.FuelGauge

  @moduledoc """
  A helper to add a fuel gauge to a scene
  """

  @doc """
  Add a guel gauge to a graph.

  The only data you need to provide is a `name` you want the fuel gauge to register itself with.
  This allows you to later send messages to the process updating the fuel level and label

  ### Examples

      graph
      |> Scenic.FuelGauge.Components.fuel_gauge(:fuel_gauge, translate: {20, 20} )
  """
  def fuel_gauge(graph, name, options \\ [])

  def fuel_gauge(%Graph{} = g, name, options) do
    add_to_graph(g, FuelGauge, name, options)
  end

  def fuel_gauge(%Primitive{module: Primitive.SceneRef} = p, name, options) do
    modify(p, FuelGauge, name, options)
  end

  defp add_to_graph(%Graph{} = g, mod, data, options) do
    mod.verify!(data)
    mod.add_to_graph(g, data, options)
  end

  defp modify(%Primitive{module: Primitive.SceneRef} = p, mod, data, options) do
    mod.verify!(data)
    Primitive.put(p, {mod, data}, options)
  end
end
