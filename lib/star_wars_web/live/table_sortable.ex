defmodule SortableTable do
  use StarWarsWeb, :live_component

  def update(assigns, socket) do
    {:ok, assign(socket, content: assigns.content, sorted_col: nil, sort_dir: nil)}
  end

  def render(assigns) do
    ~H"""
    <div id="sortable">
    <Table.table columns={["Name", "Climate", "Population", "Diameter"]} content={@content} myself={assigns.myself} />
    </div>
    """
  end

  def handle_event("sort", %{"col" => col}, socket) do
    col = String.downcase(col)
    dir = calc_dir(col, socket.assigns.sorted_col, socket.assigns.sort_dir)

    socket
    |> assign(
      content:
        socket.assigns.content
        |> Enum.sort_by(&converter(&1, col), dir),
      sorted_col: col,
      sort_dir: dir
    )

    {:noreply, socket}
  end

  def calc_dir(col, old_col, old_dir) do
    case {col == old_col, old_dir} do
      {true, :asc} -> :desc
      # {true, :desc} -> :asc
      {_, _} -> :asc
    end
  end

  def converter(a, col) do
    case Integer.parse(a[col]) do
      {val, _} -> val
      :error -> a[col]
    end
  end
end
