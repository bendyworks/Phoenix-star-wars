defmodule Table do
  use Phoenix.Component
  require IEx

  # Optionally also bring the HTML helpers
  # use Phoenix.HTML

  def sortHeaderClass(key, %{column: column, direction: direction}) do
    if column == key do
      "sorted-#{direction}"
    else
      ""
    end
  end

  def cell(assigns) do
    value = if assigns.format, do: assigns.format.(assigns.value), else: assigns.value
    ~H"""
    <td><%= value %></td>
    """
  end

  def row(assigns) do
    # IEx.pry

    ~H"""
    <tr id={@id}>
      <%= for column <- @columns do %>
        <.cell value={@row |> Map.get(column.key)} format={Map.get(column,:formatter)} />
      <% end %>
    </tr>
    """
  end

  def head(assigns) do
    ~H"""
    <thead>
      <tr>
        <%= for column <- @columns do %>
          <th class={sortHeaderClass(column.key, @sort)} >
            <span phx-click="sort" phx-value-col={column.key} phx-target={assigns.myself} >
              <%= column.header %>
            </span>
          </th>
        <% end %>
      </tr>
    </thead>
    """
  end

  def body(assigns) do
    ~H"""
    <tbody>
      <%= for row <- @content do %>
        <.row columns={@columns} row={row} id={"id-#{row.name}"} />
      <% end %>
    </tbody>
    """
  end

  def table(assigns) do
    ~H"""
    <table>
      <.head columns={@columns} myself={@myself} sort={@sort} />
      <.body columns={@columns} content={@content} />
    </table>
    """
  end
end
