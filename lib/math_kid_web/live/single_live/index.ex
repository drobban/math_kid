defmodule MathKidWeb.SingleLive.Index do
  use MathKidWeb, :live_view
  alias MathKidWeb.SingleLive.WordList

  alias MathKid.Words

  @impl true
  def mount(_params, _session, socket) do
    MathKidWeb.Endpoint.subscribe("single")

    socket =
      socket
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

  def handle_info(%{event: "new"}, socket) do
    socket =
      case socket.assigns.role do
        :student ->
          exclude = socket.assigns.exclude
          %{word: word, element: element} = get_random(exclude)

          socket
          |> assign(:word, word)
          |> assign(:exclude, exclude ++ [element])

        _ ->
          socket
      end

    {:noreply, socket}
  end

  def handle_info(%{event: "wrong"}, socket) do
    socket =
      case socket.assigns.role do
        :student ->
          exclude = socket.assigns.exclude
          %{word: word, element: element} = get_random(exclude)

          socket
          |> assign(:word, word)
          |> assign(:exclude, exclude ++ [element])
          |> assign(:wrong, socket.assigns.wrong + 1)
          |> assign(:left, socket.assigns.left - 1)

        _ ->
          socket
          |> assign(:wrong, socket.assigns.wrong + 1)
          |> assign(:left, socket.assigns.left - 1)
      end

    {:noreply, socket}
  end

  def handle_info(%{event: "correct"}, socket) do
    socket =
      case socket.assigns.role do
        :student ->
          exclude = socket.assigns.exclude
          %{word: word, element: element} = get_random(exclude)

          socket
          |> assign(:word, word)
          |> assign(:exclude, exclude ++ [element])
          |> assign(:correct, socket.assigns.correct + 1)
          |> assign(:left, socket.assigns.left - 1)

        _ ->
          socket
          |> assign(:correct, socket.assigns.correct + 1)
          |> assign(:left, socket.assigns.left - 1)
      end

    {:noreply, socket}
  end

  def handle_event("send_correct", _payload, socket) do
    MathKidWeb.Endpoint.broadcast("single", "correct", %{})
    {:noreply, socket}
  end

  def handle_event("send_new", _payload, socket) do
    MathKidWeb.Endpoint.broadcast("single", "new", %{})
    {:noreply, socket}
  end

  def handle_event("send_wrong", _payload, socket) do
    MathKidWeb.Endpoint.broadcast("single", "wrong", %{})
    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do
    exclude = socket.assigns.exclude
    %{word: word, element: element} = get_random(exclude)

    socket
    |> assign(:page_title, "Listing Singles")
    |> assign(:word, word)
    |> assign(:exclude, exclude ++ [element])
    |> assign(:role, :student)
  end

  defp apply_action(socket, :tutor, _params) do
    socket
    |> assign(:page_title, "Listing Singles")
    |> assign(:word, nil)
    |> assign(:exclude, nil)
    |> assign(:role, :tutor)
  end

  defp get_random(exclude) do
    top = WordList.get_count() - 1
    selected = Enum.random(0..top)

    if selected in exclude do
      get_random(exclude)
    else
      %{word: WordList.get_word(selected), element: selected}
    end
  end
end
