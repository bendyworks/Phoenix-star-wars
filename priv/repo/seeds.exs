# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     StarWars.Repo.insert!(%StarWars.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias StarWars.Repo
alias StarWars.Swapi
alias StarWars.Planets
alias StarWars.Planets.Planet

Repo.delete_all(Planet)

if Mix.env == :dev do
  Swapi.list_planets()
  |> Enum.each(fn el ->
    pop = if el["population"] == "unknown", do: 0, else: String.to_integer(el["population"])
    dia = if el["diameter"] == "unknown", do: 0, else: String.to_integer(el["diameter"])
    Planets.create_planet(%{
      name: el["name"],
      climate: el["climate"],
      diameter: dia,
      population: pop
    })
    # |> IO.inspect
  end)
end
