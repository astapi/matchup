defmodule Matchup.Lounge_now do
  use Ecto.Schema

  import Ecto.Changeset

  alias Matchup.Repo

  require Ecto.Query

  @derive {Poison.Encoder, only: [
    :id, :user_id, :character,
    :req_lp, :req_character,
    :rule, :pass, :comment,
    :inserted_at, :updated_at,
  ]}

  schema "lounge_now" do
    field :user_id, :integer
    field :character, :string
    field :req_lp, :integer
    field :req_character, :string
    field :rule, :integer
    field :pass, :string
    field :comment, :string
    timestamps
  end

  def list_lounge do
    Matchup.Lounge_now |> Ecto.Query.order_by(desc: :id) |> Repo.all
  end

  def create(p = %{
    "user_id" => _, "character" => _,
    "req_lp" => _, "req_character" => _,
    "rule" => _, "pass" => _,
    "comment" => _
  }) do
    params = p |> map_key_to_atom
    changeset = %Matchup.Lounge_now{} |> change(params)
    changeset |> Matchup.Repo.insert
  end

  defp map_key_to_atom(map) when is_map(map) do
    map |> Enum.reduce(%{}, fn({key, value}, ac) ->
      ac |> Map.put(String.to_atom(key), value)
    end)
  end
end
