defmodule StarWars.Planets.Planet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "planets" do
    field :climate, :string
    field :diameter, :integer
    field :name, :string
    field :population, :integer

    timestamps()
  end

  @doc false
  def changeset(planet, attrs) do
    planet
    |> cast(attrs, [:name, :climate, :population, :diameter])
    |> validate_required([:name, :climate, :population, :diameter])
  end
end
