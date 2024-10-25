defmodule RustysnekWeb.Snakes do
  require Logger
  alias Venomous.SnakeArgs
  use RustysnekWeb, :live_view

  def mount(_params, _session, socket) do
    socket = socket |> assign(:snakes, []) |> assign(:process_count, 0) |> assign(:time, nil)
    {:ok, socket}
  end

  def handle_async({:await_snake, task_id}, {:ok, snake}, socket) do
    socket =
      case snake do
        {:killed, _reason} ->
          socket

        {:retrieve_error, :max_children} ->
          put_flash(socket, :error, "Hard process limit reached. Try again later.")

        {:retrieve_error, reason} ->
          Logger.error("Could not retrieve python due to: #{inspect(reason)}")
          put_flash(socket, :error, "Internal error occured. Try again later")

        message ->
          push_event(socket, "display_message", %{text: message, process: task_id})
      end
      |> assign(:snakes, List.delete(socket.assigns.snakes, task_id))

    {:noreply, socket}
  end

  def handle_event("select_time", %{"sleep" => amount}, socket) do
    {:noreply, assign(socket, :time, amount)}
  end

  def handle_event("cancel_snake", %{"value" => snake}, socket) do
    {:noreply, cancel_async(socket, {:await_snake, snake})}
  end

  def handle_event("run_snake", %{"sleep" => amount}, socket) do
    count = socket.assigns.process_count + 1
    snakes = socket.assigns.snakes
    id = "Process: #{count}"

    socket =
      if length(snakes) >= 30 do
        socket |> put_flash(:error, "Process limit reached 30/30!")
      else
        socket
        |> start_async({:await_snake, id}, fn ->
          SnakeArgs.from_params(:rustysnek, :sleepy_constrictor, [id, amount])
          |> Venomous.python()
        end)
        |> assign(:process_count, count)
        |> assign(:snakes, [id | socket.assigns.snakes])
      end

    {:noreply, socket}
  end

  defp snake_sleep, do: %{"sleep 0s" => 0, "sleep 1s" => 1, "sleep 2s" => 2, "sleep 5s" => 5}

  attr :status, :string
  attr :name, :string

  defp snake_process(assigns) do
    ~H"""
    <div class="process-item flex items-center justify-between bg-gray-700 p-4 rounded-lg shadow transition-all duration-300 ease-in-out">
      <span class="font-medium text-gray-200"><%= @name %></span>
      <div class="flex items-center">
        <span class="text-green-400 text-sm mr-2"><%= @status %></span>
        <button
          phx-click="cancel_snake"
          value={@name}
          class="cancel-btn opacity-0 transition-opacity duration-300 ease-in-out rounded-full p-1 hover:bg-gray-600"
        >
          <svg class="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
            <path
              fill-rule="evenodd"
              d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
              clip-rule="evenodd"
            />
          </svg>
        </button>
      </div>
    </div>
    """
  end

  def terminate({:shutdown, _}, socket) do
    socket =
      Enum.reduce(socket.assigns.snakes, socket, fn snake, socket ->
        cancel_async(socket, {:await_snake, snake})
      end)

    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    {:noreply, socket}
  end
end
