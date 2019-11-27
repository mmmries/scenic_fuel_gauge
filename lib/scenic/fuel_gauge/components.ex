defmodule Scenic.FuelGauge.Components do
  alias Scenic.Graph
  alias Scenic.Primitive
  alias Scenic.FuelGauge

  @moduledoc """
  A helper to add a fuel gauge to a scene
  """

  @doc """
  Add a fuel gauge to a graph.

  Make sure to pass in data as a map with a `:gauge_sensor_id` key.
  The component will subscribe to sensor updates for the given `gauge_sensor_id`.
  You can also pass the `:fuel` key with a value betwen `0.0..1.0` to indicate the initial fuel level.
  To update this simply call `:ok = Scenic.Sensor.publish(:gauge_sensor_id, 0.75)`.

  ### Examples

      graph
      |> Scenic.FuelGauge.Components.fuel_gauge(%{gauge_sensor_id: :battery_level, fuel: 0.5}, translate: {20, 20} )
  """
  def fuel_gauge(graph, data, options \\ [])

  def fuel_gauge(%Graph{} = g, data, options) do
    add_to_graph(g, FuelGauge, data, options)
  end

  def fuel_gauge(%Primitive{module: Primitive.SceneRef} = p, data, options) do
    modify(p, FuelGauge, data, options)
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
