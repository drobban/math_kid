defmodule MathKidWeb.MultiLive.OpponentComponent do
  use MathKidWeb, :live_component

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)

    {:ok, socket}
  end

  @impl true
  def handle_event(_event, _payload, socket) do
    {:noreply, socket}
  end
end
