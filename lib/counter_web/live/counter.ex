defmodule CounterWeb.Counter do
  use CounterWeb, :live_view

  alias Phoenix.PubSub
  alias Counter.Count

  @topic Count.topic()

  def mount(_params, _session, socket) do
    PubSub.subscribe(Counter.PubSub, @topic)
    {:ok, assign(socket, val: Count.curr())}
  end

  def handle_event("inc", _, socket), do: {:noreply, assign(socket, :val, Count.incr())}
  def handle_event("dec", _, socket), do: {:noreply, assign(socket, :val, Count.decr())}

  def handle_info({:count, count}, socket), do: {:noreply, assign(socket, val: count)}

  def render(assigns) do
    ~H"""
    <.live_component module={CounterComponent} id="counter" val={@val} />
    """
  end
end
