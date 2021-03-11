defmodule PentoWeb.RatingLive.ShowComponent do
  use PentoWeb, :live_component

  def render_rating_stars(stars) do
    filled_stars(stars)
    |> Enum.concat(unfilled_stars(stars))
    |> Enum.join(" ")
  end

  defp filled_stars(stars) do
    List.duplicate("<span>&#9733;</span>", stars)
  end

  defp unfilled_stars(stars) do
    List.duplicate("<span>&#9734;</span>", 5 - stars)
  end
end
