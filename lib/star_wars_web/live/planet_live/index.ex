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
    page_size = 10 # TODO don't hard code this
    path = Routes.planet_index_path(socket, :index, %{page: page, page_size: page_size})
    IO.inspect(path, label: "update_page")
    {:noreply, push_patch(socket, to: path)}
  end

  @impl true
  def handle_info({:update_page, %{sort: sort, sort_dir: sort_dir}}, socket) do
    path = Routes.planet_index_path(socket, :index, %{sort: sort, sort_dir: sort_dir})
    IO.inspect(path, label: "update_page")
    {:noreply, push_patch(socket, to: path)}
  end

  @impl true
  def handle_info(:update_page, socket) do
    IO.inspect("found", label: "update_page")
    {:noreply, socket |> assign(something: "whatever")}
  end

  defp apply_action(socket, :index, params) do
    params = validate_params(params)
    IO.inspect(params)
    opts = Map.merge(%{
      total_records: Planets.count_planets(params),
      page_size_control: "builtin"
    }, params)
    socket
    |> assign(:page_title, "Listing Planets")
    |> assign(:planet, nil)
    |> assign(:pagination_options, opts)
    |> assign(:planets, Planets.list_planets(params))
  end

  defp validate_params(params) do
    valid_keys = [:page, :page_size, :filter, :filter_value, :sort, :sort_dir]
    for {key, val} <- params, into: %{} do
      val = cond do
        Enum.member?(["page", "page_size"], key) -> String.to_integer(val)
        Enum.member?(["sort", "sort_dir"], key) -> String.to_existing_atom(val)
      end
      {String.to_atom(key), val}
    end
    |> Map.filter(fn ({k, _v}) -> Enum.member?(valid_keys, k) end)
  end
  def number_formatter(value) do
    Delimit.number_to_delimited(value, precision: 0)
  end
end
