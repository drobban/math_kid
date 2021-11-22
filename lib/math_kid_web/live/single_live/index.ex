defmodule MathKidWeb.SingleLive.Index do
  use MathKidWeb, :live_view
  alias MathKidWeb.SingleLive.WordList

  alias MathKid.Words

  @impl true
  def mount(_params, _session, socket) do
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

  defp apply_action(socket, :index, _params) do
    exclude = socket.assigns.exclude
    %{word: word, element: element} = get_random(exclude)
    socket
    |> assign(:page_title, "Listing Singles")
    |> assign(:word, word)
    |> assign(:exclude, exclude ++ [element])
  end

  defp apply_action(socket, :tutor, _params) do
    socket
    |> assign(:page_title, "Listing Singles")
    |> assign(:single, nil)
  end

  defp get_random(exclude) do
    top = WordList.get_count()
    selected = Enum.random(0..top)
    if selected in exclude do
      get_random(exclude)
    else
      %{word: WordList.get_word(selected), element: selected}
    end
  end
end
