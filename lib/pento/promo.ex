defmodule Pento.Promo do
  alias Pento.Promo.Recipient

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_promo(%{"first_name" => first_name, "email" => email}) do
    IO.puts("
    Sending email to #{first_name} #{email}.
    ")
  end
end
