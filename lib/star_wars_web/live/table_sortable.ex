defmodule SortableTable do
  use StarWarsWeb, :live_component

  def update(assigns, socket) do
    {:ok, assign(socket, content: assigns.content, columns: assigns.columns, sorted_col: nil, sort_dir: nil)}
  end

  def render(assigns) do
    ~H"""
    <div id="sortable">
    <Table.table
      columns={@columns}
      content={@content}
      myself={@myself}
      sort={%{column: @sorted_col, direction: @sort_dir}} />
    </div>
    """
  end

  def handle_event("sort", %{"col" => col}, socket) do
    %{sorted_col: sorted_col, sort_dir: sort_dir} = socket.assigns
    col = String.to_existing_atom(col)
    dir = calc_dir(col, sorted_col, sort_dir)
    send(self(), {:update_page, %{sort: col, sort_dir: dir}})

    {:noreply, socket
      |> assign(
        sorted_col: col,
        sort_dir: dir
      )
    }
  end

  def calc_dir(col, old_col, old_dir) do
    case {col == old_col, old_dir} do
      {true, :asc} -> :desc
      {_, _} -> :asc
    end
  end
end
