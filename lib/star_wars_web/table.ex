defmodule Table do
  use Phoenix.Component

  # Optionally also bring the HTML helpers
  # use Phoenix.HTML

  def cell(assigns) do
    ~H"""
    <td><%= @value %></td>
    """
  end

  def row(assigns) do
    ~H"""
    <tr id={@id}>
      <%= for column <- @columns do %>
        <.cell value={@planet[String.downcase(column)]} />
      <% end %>
    </tr>
    """
  end

  def head(assigns) do
    ~H"""
    <thead>
      <tr>
        <%= for column <- @columns do %>
          <th><%= column %></th>
        <% end %>
      </tr>
    </thead>
    """
  end

  def body(assigns) do
    ~H"""
    <tbody>
      <%= for planet <- @planets do %>
        <.row columns={@columns} planet={planet} id={"planet-#{planet["name"]}"} />
      <% end %>
    </tbody>
    """
  end

  def table(assigns) do
    ~H"""
    <table>
      <.head columns={@columns} />
      <.body columns={@columns} planets={@planets} />
    </table>
    """
  end
end
