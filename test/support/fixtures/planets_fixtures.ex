defmodule StarWars.PlanetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `StarWars.Planets` context.
  """

  @doc """
  Generate a planet.
  """
  def planet_fixture(attrs \\ %{}) do
    {:ok, planet} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> StarWars.Planets.create_planet()

    planet
  end
end
