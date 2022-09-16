defmodule MathKidWeb.MultiLive.PlayerComponent do
  use MathKidWeb, :live_component
  import MathKidWeb.MathHelper
  alias Phoenix.LiveView.JS

  @impl true
  def update(assigns, socket) do
    player = assigns.id

    socket =
      socket
      |> assign(assigns)
      |> assign(:questions, generate_quad_options())
      |> assign(:correct, 0)
      |> assign(:wrong, 0)
      |> assign(:left, 30)
      |> assign(:exclude, [])
      |> assign(:start, DateTime.now!("Etc/UTC"))

    status = %{
      player: socket.assigns.id,
      questions: socket.assigns.questions,
      correct: socket.assigns.correct,
      wrong: socket.assigns.wrong,
      left: socket.assigns.left
    }
    MathKidWeb.Endpoint.broadcast("multiplayer", "status", status)
    {:ok, socket}
  end

  @impl true
  def handle_event("stop", _msg, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("answer", %{"answer" => ""}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("answer", %{"correct" => answer}, socket) do
    questions = socket.assigns.questions
    correct = socket.assigns.correct
    wrong = socket.assigns.wrong
    exclude = socket.assigns.exclude ++ [questions]

    correct? = answer == "true"

    socket =
      socket
      |> assign(:time, @max_time)
      |> assign(:exclude, exclude)
      |> assign(:questions, generate_quad_options())
      |> assign(:correct, if(correct?, do: correct + 1, else: correct))
      |> assign(:wrong, if(correct?, do: wrong, else: wrong + 1))
      |> assign(:left, socket.assigns.left - 1)
      |> assign(:stop, DateTime.now!("Etc/UTC"))

    status = %{
      player: socket.assigns.id,
      questions: socket.assigns.questions,
      correct: socket.assigns.correct,
      wrong: socket.assigns.wrong,
      left: socket.assigns.left
    }

    MathKidWeb.Endpoint.broadcast("multiplayer", "status", status)

    if socket.assigns.left == 0 do
      handle_event("stop", nil, socket)
    else
      {:noreply, socket}
    end
  end
end
