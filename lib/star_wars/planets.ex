defmodule StarWars.Planets do
  @moduledoc """
  The Planets context.
  """

  # alias StarWars.Repo
  # alias StarWars.Planets.Planet
  alias HTTPoison

  @base "https://swapi.dev/api/"

  @doc """
  Returns the list of planets.

  ## Examples

      iex> list_planets()
      [%Planet{}, ...]

  """
  def list_planets do
    fetch_json("planets")
  end

  defp fetch_json(path) do
    url = "#{@base}#{path}"
    IO.inspect(url)

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, Jason.decode!(body)["results"]}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, :not_found}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc """
  Gets a single planet.

  Raises `Ecto.NoResultsError` if the Planet does not exist.

  ## Examples

      iex> get_planet(123)
      %{}

      iex> get_planet(456)
      %{}

  """
  def get_planet!(id), do: fetch_json("planets/#{id}")
end
