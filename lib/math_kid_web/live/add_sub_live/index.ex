defmodule MathKidWeb.AddSubLive.Index do
  use MathKidWeb, :live_view

  alias MathKid.Basic

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:correct, 0)
      |> assign(:wrong, 0)
      |> assign(:left, 30)
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("answer", %{"answer" => ""}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("answer", %{"answer" => answer}, socket) do
    correct = socket.assigns.correct
    wrong = socket.assigns.wrong

    correct? =
      String.to_integer(answer) == calc_answer(socket.assigns.question)

    socket =
      socket
      |> assign(:question, generate_calc())
      |> assign(:correct, (if correct?, do: correct + 1, else: correct))
      |> assign(:wrong, (if correct?, do: wrong, else: wrong + 1))
      |> assign(:left, socket.assigns.left - 1)

    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Add subs")
    |> assign(:question, generate_calc())
  end


  defp generate_calc() do
    top = 10
    a = Enum.random(0..top)
    b = Enum.random(0..(top - a))
    op = Enum.random(0..1)

    question =
      %{a: a, b: b, operator: op}

    if calc_answer(question) < 0  do
      generate_calc()
    else
      question
    end
  end

  defp calc_answer(%{a: a, b: b, operator: op}) do
    case op do
      1 ->
        a + b
      0 ->
        a - b
      _ ->
        nil
    end
  end
end
