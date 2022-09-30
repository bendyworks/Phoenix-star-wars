defmodule Pagination do
  use Phoenix.Component
  require IEx

  use Phoenix.HTML

  def prev_button(assigns) do
    ~H"""
    <%= if @page > 1 do %>
    <a phx-target={@myself} phx-click="page" phx-value-page={@page - 1}>&lt;</a>
    <% end %>
    """
  end

  def next_button(assigns) do
    ~H"""
    <%= if @page < @total_pages do %>
    <a phx-target={@myself} phx-click="page" phx-value-page={@page + 1}>&gt;</a>
    <% end %>
    """
  end

  def page_numbers(assigns) do
    ~H"""
    <%= for cur_page <- 1..@total_pages do %>
      <%= if @page == cur_page do %>
        <%= cur_page %>
      <% else %>
        <a phx-target={@myself} phx-click="page" phx-value-page={cur_page}><%= cur_page %></a>
      <% end %>
    <% end %>
    """
  end

  def page_size_control(%{page_size_control: ctrl} = assigns) when is_binary(ctrl) and ctrl == "none", do: ~H"""
  """

  def page_size_control(%{page_size_control: ctrl} = assigns) when is_nil(ctrl), do: page_size_control(Map.merge(assigns, %{page_size_control: "builtin"}))

  def page_size_control(%{page_size_control: ctrl} = assigns) when is_function(ctrl), do: ctrl.(assigns)

  def page_size_control(%{page_size_control: ctrl} = assigns) when is_binary(ctrl) and ctrl == "builtin" do
    types = %{page_size: :integer}
    changeset = {%{}, types}
      |> Ecto.Changeset.cast(%{page_size: assigns.page_size}, Map.keys(types))
    ~H"""
    <.form let={f} for={changeset} as="page_size" phx-change="page_size" phx-target={@myself} >
      <span class="page_size_prefix">Show</span>
      <%= select f, :page_size, [10, 20, 50, 100], selected: @page_size %>
      <span class="page_size_suffix">per page</span>
    </.form>
    """
  end

  def page_size_control(assigns), do: page_size_control(%{page_size: assigns.page_size, page_size_control: "builtin"})

  def pages(%{total_records: total_records, page: page, page_size: page_size, page_size_control: page_size_control} = assigns) do
    total_pages = ceil(total_records / page_size)

    ~H"""
    <div class="pagination">
      <.prev_button myself={@myself} page={page} />
      <.page_numbers myself={@myself} page={page} total_pages={total_pages} />
      <.next_button myself={@myself} page={page} total_pages={total_pages} />
      <.page_size_control myself={@myself} page_size={page_size} page_size_control={page_size_control} />
    </div>
    """
  end
end
