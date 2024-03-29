defmodule MathKidWeb.MultiLive.Index do
  use MathKidWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    MathKidWeb.Endpoint.subscribe("multiplayer")

    socket =
      socket
      |> assign(:player, nil)
      |> assign(:connected, [])
      |> assign(:opponent, nil)
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

    connected =
      case payload[:player] do
        nil ->
          # Echo from self...
          socket.assigns.connected

        x ->
          Enum.uniq(socket.assigns.connected ++ [x])
      end

    {:noreply, socket |> assign(:connected, connected)}
  end

  @impl true
  def handle_info(%{event: "connected", payload: payload}, socket) do

    connected =
      case payload[:player] do
        nil ->
          # Error case. Should not happen.
          socket.assigns.connected

        x ->
          Enum.uniq(socket.assigns.connected ++ [x])
      end

    {:noreply, socket |> assign(:connected, connected)}
  end

  @impl true
  def handle_info(%{event: "status", payload: payload}, socket) do

    %{player: player, questions: questions, correct: correct, wrong: wrong} = payload

    socket =
    if player != socket.assigns.player do

      # send_update(MathKidWeb.MultiLive.PlayerComponent, id: socket.assigns.player, opponent: true)
      socket
      |> assign(opponent: payload)
    else
      socket
    end


    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do
    MathKidWeb.Endpoint.broadcast("multiplayer", "ping", %{})

    socket
    |> assign(:page_title, "Multiplayer")
  end
end
