defmodule MathKidWeb.MultipleLive.Index do
  use MathKidWeb, :live_view

  import MathKidWeb.MultiplesHelper

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

  @impl true
  def handle_event("answer", %{"answer" => ""}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("answer", %{"answer" => answer}, socket) do
    question = socket.assigns.question
    correct = socket.assigns.correct
    wrong = socket.assigns.wrong
    exclude = socket.assigns.exclude ++ [question]

    correct? = String.to_integer(answer) == calc_answer(socket.assigns.question)

    socket =
      socket
      |> assign(:exclude, exclude)
      |> assign(:question, generate_calc())
      |> assign(:correct, if(correct?, do: correct + 1, else: correct))
      |> assign(:wrong, if(correct?, do: wrong, else: wrong + 1))
      |> assign(:left, socket.assigns.left - 1)
      |> assign(:stop, DateTime.now!("Etc/UTC"))

    IO.inspect(socket.assigns)
    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do

    socket
    |> assign(:page_title, "Multiplikation")
    |> assign(:question, generate_calc())
  end
end
