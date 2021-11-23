defmodule MathKidWeb.SpeedLive.Index do
  use MathKidWeb, :live_view
  import MathKidWeb.MathHelper
  @max_time 70
  @step 100

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:max_time, @max_time)
      |> assign(:time, @max_time)
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
  def handle_info(%{msg: :time_out}, socket) do
    timer = Process.send_after(self(), %{msg: :time_out}, @step)
    time = socket.assigns.time

    if time == 0 do
      socket =
        socket
        |> assign(:timer, timer)
        |> assign(:time, @max_time)

      handle_event("answer", %{"answer" => nil}, socket)
    else
      socket =
        socket
        |> assign(:timer, timer)
        |> assign(:time, time - 1)

      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("answer", %{"answer" => ""}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("start", _msg, socket) do
    socket =
      socket
      |> assign(:timer, Process.send_after(self(), %{msg: :time_out}, @step))

    {:noreply, socket}
  end

  @impl true
  def handle_event("stop", _msg, socket) do
    Process.cancel_timer(socket.assigns.timer)

    socket =
      socket
      |> assign(:timer, nil)

    {:noreply, socket}
  end

  @impl true
  def handle_event("answer", %{"answer" => answer}, socket) do
    question = socket.assigns.question
    correct = socket.assigns.correct
    wrong = socket.assigns.wrong
    exclude = socket.assigns.exclude ++ [question]

    correct? =
      if is_binary(answer) do
        String.to_integer(answer) == calc_answer(socket.assigns.question)
      else
        false
      end

    socket =
      socket
      |> assign(:time, @max_time)
      |> assign(:exclude, exclude)
      |> assign(:question, generate_calc(exclude))
      |> assign(:correct, if(correct?, do: correct + 1, else: correct))
      |> assign(:wrong, if(correct?, do: wrong, else: wrong + 1))
      |> assign(:left, socket.assigns.left - 1)
      |> assign(:stop, DateTime.now!("Etc/UTC"))

    IO.inspect(socket.assigns)

    if socket.assigns.left == 0 do
      handle_event("stop", nil, socket)
    else
      {:noreply, socket}
    end
  end

  defp apply_action(socket, :index, _params) do
    exclude = socket.assigns.exclude

    socket
    |> assign(:page_title, "Listing Add subs")
    |> assign(:question, generate_calc(exclude))
  end
end
