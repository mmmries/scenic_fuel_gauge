defmodule Scenic.FuelGaugeTest do
  use ExUnit.Case
  alias Scenic.FuelGauge

  @state %{
    data: %{fuel: 0.5},
    opts: %{styles: %{font: :roboto, font_size: 24}}
  }

  test "init" do
    {:ok, _, push: _} = FuelGauge.init(%{gauge_sensor_id: :test_name}, styles: %{})
  end

  test "handle_info {:fuel, level}" do
    timestamp = :os.system_time(:micro_seconds)
    sensor_message = {:sensor, :data, {:test_name, 0.5, timestamp}}
    assert {:noreply, new_state, push: _} = FuelGauge.handle_info(sensor_message, @state)
    assert new_state.data.fuel == 0.5
  end
end
