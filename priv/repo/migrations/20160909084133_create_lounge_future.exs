defmodule Matchup.Repo.Migrations.CreateLoungeFuture do
  use Ecto.Migration

  def change do
    create table(:lounge_future) do
      add :user_id, :integer
      add :character, :string
      add :req_lp, :integer
      add :req_character, :string
      add :rule, :integer
      add :pass, :string
      add :started_at, :datetime
      add :end_at, :datetime
      add :comment, :string, size: 400
      timestamps
    end
  end
end
