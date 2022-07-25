defmodule StarWars.Swapi do
  @moduledoc """
  The Star Wars API fetchers
  """
  alias HTTPoison

  @base "https://swapi.dev/api/"

  @doc """
  Returns the list of planets.

  ## Examples

      iex> list_planets()
      [%{}, ...]

  """
  def list_planets do
    fetch_list("#{@base}planets")
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

  @doc """
  Returns the list of people.

  ## Examples

      iex> list_people()
      [%{}, ...]

  """
  def list_people do
    fetch_list("#{@base}people")
  end

  defp fetch_list(url), do: fetch_list(url, [])
  defp fetch_list(nil, acc), do: acc

  defp fetch_list(url, acc) do
    %{"next" => next, "results" => results} =
      HTTPoison.get!(url)
      |> Map.get(:body)
      |> Jason.decode!

    fetch_list(next, acc ++ results)
  end


  defp fetch_json(path) do
    url = "#{@base}#{path}"
    # IO.inspect(url)

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        data = Jason.decode!(body)
        {:ok, data["results"], data["next"]}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, :not_found}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

end
