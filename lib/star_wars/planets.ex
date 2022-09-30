defmodule StarWars.Planets do
  @moduledoc """
  The Planets context.
  """

  alias StarWars.{Repo, Pagination}
  alias StarWars.Planets.Planet
  import Ecto.Query

  @default_sort :name

  @type query_options() :: %{
    optional(:page) => number(),
    optional(:page_size) => number(),
    optional(:sort) => atom(),
    optional(:sort_dir) => atom(),
    optional(:filter) => atom(),
    optional(:filter_value) => any()
  }

  @spec count_planets() :: list(%Planet{})
  @spec count_planets(query_options()) :: list(%Planet{})
  @doc """
  returns the total count of records

  ## Examples

    iex> count_planets()
    2

  """
  def count_planets(opts \\ %{}) do
    Planet
    |> filter(opts)
    |> Pagination.page_count()
  end

  @spec list_planets() :: list(%Planet{})
  @spec list_planets(query_options()) :: list(%Planet{})
  @doc """
  Returns the list of planets.

  ## Examples

      iex> list_planets()
      [%Planet{}, ...]

  """
  def list_planets(opts \\ %{}) do
    Planet
    |> filter(opts)
    |> paginate(opts)
    |> sort(opts)
    |> Repo.all
  end

  @spec get_planet!(number()) :: %Planet{}
  @doc """
  Gets a single planet.

  Raises `Ecto.NoResultsError` if the Planet does not exist.

  ## Examples

      iex> get_planet!(123)
      %Planet{}

      iex> get_planet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_planet!(id), do: Repo.get!(Planet, id)

  @spec create_planet(map()) :: {:ok, %Planet{}} | {:error, %Ecto.Changeset{}}
  @doc """
  Creates a planet.

  ## Examples

      iex> create_planet(%{field: value})
      {:ok, %Planet{}}

      iex> create_planet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_planet(attrs \\ %{}) do
    %Planet{}
    |> Planet.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_planet(%Planet{}, map()) :: {:ok, %Planet{}} | {:error, %Ecto.Changeset{}}
  @doc """
  Updates a planet.

  ## Examples

      iex> update_planet(planet, %{field: new_value})
      {:ok, %Planet{}}

      iex> update_planet(planet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_planet(%Planet{} = planet, attrs) do
    planet
    |> Planet.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_planet(%Planet{}) :: {:ok, %Planet{}} | {:error, %Ecto.Changeset{}}
  @doc """
  Deletes a planet.

  ## Examples

      iex> delete_planet(planet)
      {:ok, %Planet{}}

      iex> delete_planet(planet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_planet(%Planet{} = planet) do
    Repo.delete(planet)
  end

  @spec change_planet(%Planet{}, map()) :: %Ecto.Changeset{}
  @doc """
  Returns an `%Ecto.Changeset{}` for tracking planet changes.

  ## Examples

      iex> change_planet(planet)
      %Ecto.Changeset{data: %Planet{}}

  """
  def change_planet(%Planet{} = planet, attrs \\ %{}) do
    Planet.changeset(planet, attrs)
  end

# private

  # takes a query and opts and returns a query with the opts for page and page_size applied
  defp paginate(q, opts) do
    page_size = if Map.has_key?(opts, :page_size), do: opts.page_size, else: 0
    page = if Map.has_key?(opts, :page) do
      if opts.page < 1, do: 1, else: opts.page
    end
    q |> Pagination.query(page, page_size)
  end

  # takes a query and opts and returns a query with the opts for sort and sort_dir applied
  defp sort(q, opts) do
    fields = Planet.__schema__(:fields)
    sort = if Map.has_key?(opts, :sort) do
      if Enum.member?(fields, opts.sort), do: opts.sort, else: @default_sort
    else
      @default_sort
    end
    direction = if Map.has_key?(opts, :sort_dir) && opts.sort_dir == :desc, do: :desc, else: :asc
    sort = if direction == :desc, do: [desc: sort], else: [asc: sort]
    order_by(q, ^sort)
  end

  # takes a query and opts and returns a query with the opts for sort and sort_dir applied
  defp filter(q, opts) do
    fields = Planet.__schema__(:fields)
    filter = if Map.has_key?(opts, :filter) && Enum.member?(fields, opts.filter) do
      opts.filter
    else
      :none
    end
    value = if Map.has_key?(opts, :filter_value) && String.trim(opts.filter_value) do
      String.trim(opts.filter_value)
    else
      :none
    end
    value = if filter != :none && value != :none do
      attrs = Map.new([{filter, value}])
      changeset = Ecto.Changeset.cast(%Planet{}, attrs, [filter])
      if changeset.valid?, do: Map.get(changeset.changes, filter), else: :none
    else
      :none
    end
    if value != :none do
      if is_binary(value) do
        where(q, [p], ilike(field(p, ^filter), ^"#{value}%"))
      else
        value = [filter, value]
        where(q, ^value)
      end
    else
      q
    end
  end
end
