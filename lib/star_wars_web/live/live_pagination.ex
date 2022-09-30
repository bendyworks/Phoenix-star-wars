defmodule LivePagination do
  use StarWarsWeb, :live_component

  @default_opts %{
    page: 1,
    page_size: 10,
    page_size_control: "builtin",
  }

  def update(assigns, socket) do
    {:ok, assign(socket, Map.merge(@default_opts, assigns.pagination_options))}
  end

  def render(assigns) do
    Pagination.pages(Map.merge(assigns, %{myself: assigns.myself}))
  end

  def handle_event("page", %{"page" => page}, socket) do
    opts = socket.assigns
    total_pages = ceil(opts.total_records / opts.page_size)
    page = String.to_integer(page)
    page = if page < 1 or page > total_pages, do: 1, else: page
    if connected?(socket) do
      # send(self(), {:update, %{page: page}})
      send(self(), {:update_page, %{page: page}})
      IO.inspect(self(), label: "page event")
    else
      IO.inspect("not connected")
    end
    {:noreply, socket |> assign(page: page)}
  end

  def handle_event("page_size", %{"page_size" => %{"page_size" => page_size}}, socket) do
    page_size = String.to_integer(page_size)
    page_size = if page_size < 1, do: 10, else: page_size
    if connected?(socket) do
      IO.inspect(page_size, label: "page_size event")
      send(self(), {:update_page_size, %{page_size: page_size}})
    end
    {:noreply, socket |> assign(page_size: page_size, page: 1)}
  end
end
