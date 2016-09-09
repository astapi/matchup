defmodule Matchup.Repo.Migrations.CreateLoungeNow do
  use Ecto.Migration

  def change do
    create table(:lounge_now) do
      add :user_id, :integer
      add :character, :string
      add :req_lp, :integer
      add :req_character, :string
      add :rule, :integer
      add :pass, :string
      add :comment, :string, size: 400
    end
  end
end
