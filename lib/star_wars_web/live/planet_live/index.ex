defmodule StarWarsWeb.PlanetLive.Index do
  use StarWarsWeb, :live_view

  alias StarWars.Planets
  alias Number.Delimit

  @impl true
  def mount(_params, _session, socket) do
    planets = Planets.list_planets()
    {:ok, assign(socket, :planets, planets)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info({:update_page, %{page: page}}, socket) do
    page_size = 10
    path = Routes.planet_index_path(socket, :index, %{page: page, page_size: page_size})
    IO.inspect(path, label: "update_page")
    {:noreply, push_patch(socket, to: path)}
  end

  @impl true
  def handle_info(:update_page, socket) do
    IO.inspect("found", label: "update_page")
    {:noreply, socket |> assign(something: "whatever")}
  end

  defp apply_action(socket, :index, params) do
    opts = Map.merge(%{
      total_records: 101,
      page_size_control: "builtin"
    }, params)
    socket
    |> assign(:page_title, "Listing Planets")
    |> assign(:planet, nil)
    |> assign(:pagination_options, opts)
  end

  def number_formatter(value) do
    Delimit.number_to_delimited(value, precision: 0)
  end
end
