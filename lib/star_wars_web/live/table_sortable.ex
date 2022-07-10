defmodule SortableTable do
  use StarWarsWeb, :live_component

  def update(assigns, socket) do
    {:ok, assign(socket, content: assigns.content, columns: assigns.columns, sorted_col: nil, sort_dir: nil)}
  end

  def render(assigns) do
    ~H"""
    <div id="sortable">
    <Table.table columns={@columns} content={@content} myself={assigns.myself} />
    </div>
    """
  end

  def handle_event("sort", %{"col" => col}, socket) do
    col = String.downcase(col)
    dir = calc_dir(col, socket.assigns.sorted_col, socket.assigns.sort_dir)

    content = socket.assigns.content
    |> Enum.sort_by(&Map.get(&1, String.to_atom(col)), dir)

    {:noreply, socket
      |> assign(
        content: content,
        sorted_col: col,
        sort_dir: dir
      )
    }
  end

  def calc_dir(col, old_col, old_dir) do
    case {col == old_col, old_dir} do
      {true, :asc} -> :desc
      # {true, :desc} -> :asc
      {_, _} -> :asc
    end
  end

end
