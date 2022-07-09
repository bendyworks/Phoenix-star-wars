defmodule StarWars.Repo.Migrations.UpdatePlanets do
  use Ecto.Migration

  def change do
    alter table(:planets) do
      add :climate, :string
      add :population, :bigint
      add :diameter, :integer
    end
  end
end
