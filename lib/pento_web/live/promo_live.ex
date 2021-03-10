defmodule PentoWeb.PromoLive do
  use PentoWeb, :live_view
  alias Pento.Promo
  alias Pento.Promo.Recipient

  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign_recipient()
      |> assign_changeset()
    }
  end

  def handle_event(
        "validate",
        %{"recipient" => recipient_params},
        %{assigns: %{recipient: recipient}} = socket
      ) do
    changeset =
      recipient
      |> Promo.change_recipient(recipient_params)
      |> Map.put(:action, :validate)

    {
      :noreply,
      socket
      |> assign(:changeset, changeset)
    }
  end

  def handle_event("save", %{"recipient" => recipient_params}, socket) do
    # to test showing phx_disable_with
    :timer.sleep(1000)
    submit_promo_email(socket, recipient_params)
  end

  defp submit_promo_email(%{assigns: %{changeset: changeset}} = socket, params) do
    if changeset.valid? do
      Promo.send_promo(params)

      {
        :noreply,
        socket
        |> put_flash(:info, "Promo email sent!")
        |> push_redirect(to: "/promo")
      }
    else
      {:noreply, socket}
    end
  end

  defp assign_recipient(socket) do
    socket
    |> assign(:recipient, %Recipient{})
  end

  defp assign_changeset(%{assigns: %{recipient: recipient}} = socket) do
    socket
    |> assign(:changeset, Promo.change_recipient(recipient))
  end
end
