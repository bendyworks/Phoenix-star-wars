defmodule Table do
  use Phoenix.Component
  require IEx

  # Optionally also bring the HTML helpers
  # use Phoenix.HTML

  def cell(assigns) do
    ~H"""
    <td><%= @value %></td>
    """
  end

  def row(assigns) do
    # IEx.pry

    ~H"""
    <tr id={@id}>
      <%= for column <- @columns do %>
        <.cell value={@row |> Map.get(String.downcase(column) |> String.to_atom)} />
      <% end %>
    </tr>
    """
  end

  def head(assigns) do
    ~H"""
    <thead>
      <tr>
        <%= for column <- @columns do %>
          <th><span phx-click="sort" phx-value-col={column} phx-target={assigns.myself} ><%= column %></span></th>
        <% end %>
      </tr>
    </thead>
    """
  end

  def body(assigns) do
    ~H"""
    <tbody>
      <%= for row <- @content do %>
        <.row columns={@columns} row={row} id={"planet-#{row.name}"} />
      <% end %>
    </tbody>
    """
  end

  def table(assigns) do
    ~H"""
    <table>
      <.head columns={@columns} myself={@myself} />
      <.body columns={@columns} content={@content} />
    </table>
    """
  end
end
