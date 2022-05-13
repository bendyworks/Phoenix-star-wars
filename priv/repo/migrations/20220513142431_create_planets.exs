defmodule StarWars.Repo.Migrations.CreatePlanets do
  use Ecto.Migration

  def change do
    create table(:planets) do
      add :name, :string

      timestamps()
    end
  end
end
