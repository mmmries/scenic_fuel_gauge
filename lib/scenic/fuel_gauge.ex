defmodule Scenic.FuelGauge do
  use Scenic.Component, has_children: false
  alias Scenic.Graph
  import Scenic.Primitives

  @moduledoc """
  A Scenic.Component that draws a fuel gauge

  Example:
      Scenic.Graph.build(font: :roboto, font_size: @text_size)
      |> Scenic.FuelGauge.Components.fuel_gauge(%{gauge_sensor_id: :battery_level}, [scale: {3.0, 3.0}, translate: {80, 40}])

  That will draw something like this:

  ![Example Gauge](gauge.png)
  """

  @doc false
  def verify(%{gauge_sensor_id: sensor_id} = data) when is_atom(sensor_id), do: {:ok, data}
  def verify(_), do: :invalid_data

  @doc false
  def init(%{gauge_sensor_id: gauge_sensor_id} = data, opts) do
    :ok = Scenic.Sensor.subscribe(gauge_sensor_id)
    fuel = Map.get(data, :fuel, 0.0)
    state = %{
      data: %{
        fuel: fuel,
      },
      opts: opts
    }
    graph = build_graph(state)
    {:ok, state, push: graph}
  end

  def handle_info({:sensor, :registered, _metadata}, state) do
    {:noreply, state}
  end

  def handle_info({:sensor, :unregistered, _sensor_id}, state) do
    {:noreply, state}
  end

  def handle_info({:sensor, :data, {_sensor_id, level, _timestamp}}, state) do
    state = put_in(state, [:data, :fuel], level)
    graph = build_graph(state)
    {:noreply, state, push: graph}
  end

  defp build_graph(state) do
    styles = state[:opts][:styles]
    Graph.build(styles: styles) |> draw(state[:data], state[:opts])
  end

  defp draw(graph, data, opts) do
    group(graph, &build_group(&1, data), opts)
  end

  defp build_group(graph, data) do
    graph |> add_gauge(data) |> add_needle(data)
  end

  defp add_gauge(group, _data) do
    group
    |> arc({90, :math.pi() * -0.8, :math.pi() * -0.2}, stroke: {4, :white}, translate: {100, 100})
    |> line({{0, 0}, {8, 8}}, stroke: {6, :white}, translate: {29, 45})
    |> line({{0, 0}, {-8, 8}}, stroke: {6, :white}, translate: {171, 45})
  end

  @min_rotation -0.3 * :math.pi()
  @max_rotation_travel 0.6 * :math.pi()
  defp add_needle(graph, data) do
    fuel_level = Map.get(data, :fuel, 0.5)
    clamped = clamp(fuel_level)
    rotation = @min_rotation + @max_rotation_travel * clamped

    group(graph, &build_needle/1, rotate: rotation, translate: {100, 100})
  end

  defp build_needle(group) do
    group
    |> circle(12, fill: {200, 50, 50}, stroke: {1, :white})
    |> triangle({{-8, 0}, {0, -85}, {8, 0}}, fill: {200, 50, 50})
  end

  defp clamp(num) when num <= 0.0, do: 0.0
  defp clamp(num) when num >= 1.0, do: 1.0
  defp clamp(num), do: num
end
