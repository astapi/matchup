defmodule Matchup.Repo.Migrations.CreateSf5Users do
  use Ecto.Migration

  def change do
    create table(:sf5_users) do
      add :game_id, :string
      add :lp, :integer
      add :character, :string
      timestamps
    end
  end
end
