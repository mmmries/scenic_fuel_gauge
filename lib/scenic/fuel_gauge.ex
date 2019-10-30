defmodule Scenic.FuelGauge do
  import Scenic.Primitives

  @doc """
  Draw a fuel gauge on your scene graph

  This function takes in a graph and draws a fuel gauge on that graph.
  The second argument is map where you can provide a `fuel` float between `0.0 .. 1.0`.
  This third argument is a standard set of scenic options that you can pass to a group, this is a convenience for doing scaling, rotating, etc
  """
  @spec draw(Scenic.Graph.t(), %{fuel: float()}, keyword()) :: Scenic.Graph.t()
  def draw(graph, data, opts \\ []) do
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
