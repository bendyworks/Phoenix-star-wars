defmodule StarWars.Pagination do
  import Ecto.Query
  alias StarWars.Repo

  def query(query, page, page_size) do
    if page_size > 0 do
      query |> limit(^page_size) |> offset(^((page - 1) * page_size))
    else
      query
    end
  end

  def page_count(query) do
    Repo.one(from(t in subquery(query), select: count("*")))
  end
end
