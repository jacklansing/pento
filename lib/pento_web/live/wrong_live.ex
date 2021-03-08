defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView

  def mount(_params, session, socket) do
    {
      :ok,
      assign(
        socket,
        score: 0,
        message: "Guess a number.",
        time: time(),
        user: Pento.Accounts.get_user_by_session_token(session["user_token"]),
        session_id: session["live_socket_id"]
      )
    }
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    {result, message} = determine_correct_answer(guess)
    score = determine_updated_score(result, socket.assigns.score)

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        time: time()
      )
    }
  end

  defp determine_correct_answer(guess) do
    correct_number = :rand.uniform(10)
    {guess_number, _rem} = Integer.parse(guess)

    case correct_number == guess_number do
      true -> {:correct, "Your guess: #{guess}. Correct!. Guess again for more points!"}
      false -> {:wrong, "Your guess: #{guess}. Wrong. Guess again."}
    end
  end

  defp determine_updated_score(result, score) do
    case result do
      :correct -> score + 10
      :wrong -> score - 1
    end
  end

  def render(assigns) do
    ~L"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number="<%= n %>"><%= n %></a>
      <% end %>
    </h2>
    <pre>
      <%= @user.email %>
      <%= @session_id %>
    </pre>
    """
  end

  def time() do
    DateTime.utc_now() |> to_string
  end
end
