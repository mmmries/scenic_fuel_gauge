defmodule Scenic.FuelGaugeTest do
  use ExUnit.Case
  alias Scenic.FuelGauge

  @state %{
    data: %{fuel: 0.5},
    opts: %{styles: %{font: :roboto, font_size: 24}}
  }

  test "init" do
    {:ok, _, push: _} = FuelGauge.init(:test_name, styles: %{})
  end

  test "handle_info {:fuel, level}" do
    assert {:noreply, state, push: _} = FuelGauge.handle_info({:fuel, 0.5}, @state)
  end
end
