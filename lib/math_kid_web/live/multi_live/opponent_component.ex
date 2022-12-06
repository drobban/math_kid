defmodule MathKidWeb.MultiLive.OpponentComponent do
  use MathKidWeb, :live_component

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)

    {:ok, socket}
  end


end
