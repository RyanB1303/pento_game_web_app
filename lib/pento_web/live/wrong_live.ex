defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  # alias Pento.Accounts

  def mount(__params, session, socket) do
    {:ok,
     assign(socket,
       score: 0,
       message: "Make a guess",
       answer: answer(),
       time: time(),
       answered: false,
       session_id: session["live_socket_id"],
       username: socket.assigns.current_user.username
     )}
  end

  def handle_event("restart", _, socket) do
    {:noreply,
     assign(socket,
       score: 0,
       message: "Make a guess",
       answer: answer(),
       time: time(),
       answered: false
     )}
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    answer = socket.assigns.answer |> to_string()

    if guess == answer do
      message = "Your guess #{guess}. Correct. Congratulations!"
      score = socket.assigns.score + 5

      {
        :noreply,
        assign(socket, score: score, message: message, time: time(), answered: true)
      }
    else
      message = "Your guess #{guess}. Wrong. Guess again. "
      score = socket.assigns.score - 1

      {
        :noreply,
        assign(socket, score: score, message: message, time: time())
      }
    end
  end

  def time() do
    DateTime.utc_now() |> to_string()
  end

  def answer() do
    Enum.random(1..10)
  end

  def render(assigns) do
    ~H"""
    <h1>Username: <%= @username %></h1>
    <h2>Score: <%= @score %></h2>
    <%= if @answered do %>
      <p>Well Done!</p>
      <a href="#" phx-click="restart" >
        Restart</a>
    <% end %>
    <h2>
    <p>Guess the number</p>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number= {n}>
          <%= n %></a>
      <% end %>
    </h2>
    """
  end
end
