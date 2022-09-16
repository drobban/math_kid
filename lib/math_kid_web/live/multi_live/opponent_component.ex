defmodule MathKidWeb.MultiLive.OpponentComponent do
  use MathKidWeb, :live_component


  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
    }
  end

  @impl true
  def handle_event(_event, _payload, socket) do

    {:noreply, socket}
  end
end
