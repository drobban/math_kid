defmodule MathKidWeb.MultiLive.Index do
  use MathKidWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    MathKidWeb.Endpoint.subscribe("multiplayer")

    socket =
      socket
      |> assign(:player, nil)
      |> assign(:connected, [])
      |> assign(:correct, 0)
      |> assign(:wrong, 0)
      |> assign(:left, 30)
      |> assign(:exclude, [])
      |> assign(:start, DateTime.now!("Etc/UTC"))

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("player", %{"player" => name}, socket) do

    socket =
      socket
      |> assign(:player, name)

    MathKidWeb.Endpoint.broadcast("multiplayer", "connected", %{player: name})
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "ping"}, socket) do
    player = socket.assigns.player
    MathKidWeb.Endpoint.broadcast("multiplayer", "pong", %{player: player})

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "pong", payload: payload}, socket) do
    IO.inspect("Got pong")

    connected =
    case payload[:player] do
      nil ->
        IO.inspect("none connected")
        socket.assigns.connected
      x ->
        socket.assigns.connected ++ [x]
    end

    {:noreply, socket |> assign(:connected, connected)}
  end

  @impl true
  def handle_info(%{event: "connected", payload: payload}, socket) do
    IO.inspect("Got connection")
    IO.inspect(payload[:player])

    connected =
      case payload[:player] do
        nil ->
          IO.inspect("none connected")
          socket.assigns.connected
        x ->
          socket.assigns.connected ++ [x]
      end

    {:noreply, socket |> assign(:connected, connected)}
  end


  defp apply_action(socket, :index, _params) do
    MathKidWeb.Endpoint.broadcast("multiplayer", "ping", %{})

    socket
    |> assign(:page_title, "Multiplayer")
  end

end
