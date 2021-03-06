defmodule StarWars.PlanetsTest do
  use StarWars.DataCase

  alias StarWars.Planets

  describe "planets" do
    alias StarWars.Planets.Planet

    import StarWars.PlanetsFixtures

    @invalid_attrs %{name: nil}

    test "list_planets/0 returns all planets" do
      planet = planet_fixture()
      assert Planets.list_planets() == [planet]
    end

    test "get_planet!/1 returns the planet with given id" do
      planet = planet_fixture()
      assert Planets.get_planet!(planet.id) == planet
    end

    test "create_planet/1 with valid data creates a planet" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Planet{} = planet} = Planets.create_planet(valid_attrs)
      assert planet.name == "some name"
    end

    test "create_planet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Planets.create_planet(@invalid_attrs)
    end

    test "update_planet/2 with valid data updates the planet" do
      planet = planet_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Planet{} = planet} = Planets.update_planet(planet, update_attrs)
      assert planet.name == "some updated name"
    end

    test "update_planet/2 with invalid data returns error changeset" do
      planet = planet_fixture()
      assert {:error, %Ecto.Changeset{}} = Planets.update_planet(planet, @invalid_attrs)
      assert planet == Planets.get_planet!(planet.id)
    end

    test "delete_planet/1 deletes the planet" do
      planet = planet_fixture()
      assert {:ok, %Planet{}} = Planets.delete_planet(planet)
      assert_raise Ecto.NoResultsError, fn -> Planets.get_planet!(planet.id) end
    end

    test "change_planet/1 returns a planet changeset" do
      planet = planet_fixture()
      assert %Ecto.Changeset{} = Planets.change_planet(planet)
    end
  end
end
