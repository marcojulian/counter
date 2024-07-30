defmodule Counter.Count do
  use GenServer

  alias Phoenix.PubSub

  @name :count_server
  @start_value 0

  def topic, do: "count"

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, @start_value, name: @name)
  end

  def init(start_count) do
    {:ok, start_count}
  end

  def incr(), do: GenServer.call(@name, :incr)
  def decr(), do: GenServer.call(@name, :decr)
  def curr(), do: GenServer.call(@name, :curr)

  def handle_call(:incr, _, count), do: make_change(count, +1)
  def handle_call(:decr, _, count), do: make_change(count, -1)
  def handle_call(:curr, _, count), do: {:reply, count, count}

  defp make_change(count, change) do
    new_count = count + change
    PubSub.broadcast(Counter.PubSub, topic(), {:count, new_count})
    {:reply, new_count, new_count}
  end
end
