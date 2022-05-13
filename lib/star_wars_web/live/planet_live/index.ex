defmodule StarWarsWeb.PlanetLive.Index do
  use StarWarsWeb, :live_view

  alias StarWars.Planets

  @impl true
  def mount(_params, _session, socket) do
    planets = list_planets()
    IO.inspect(planets)
    {:ok, assign(socket, :planets, planets)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Planets")
    |> assign(:planet, nil)
  end

  defp list_planets do
    case Planets.list_planets() do
      {:ok, planets} -> planets
      {:error, _} -> []
    end
  end
end
