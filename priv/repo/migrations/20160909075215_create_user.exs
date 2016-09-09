defmodule Matchup.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :twitter_token, :string, size: 500
      timestamps
    end
  end
end
