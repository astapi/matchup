defmodule Matchup.Sf5_User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Matchup.Repo

  require Ecto.Query

  @derive {Poison.Encoder, only: [
    :id, :user_id, :game_id, :lp, :character, :inserted_at, :updated_at
  ]}

  schema "sf5_users" do
    field :user_id, :integer
    field :game_id, :string
    field :lp, :integer
    field :character, :string
    timestamps
  end
  
  def update_or_insert(p = %{
    "user_id" => uid,
    "game_id" => _gid, "lp" => _lp, "character" => _character
    }) do
    #TODO characterを定義リストの中にあるかガードで見る
    case Matchup.Sf5_User |> Ecto.Query.where(user_id: ^uid) |> Repo.one do
      nil -> insert(p)
      sf5_user -> update(sf5_user, p)
    end
  end

  defp update(user, p) when is_map(p) do
    params = map_key_to_atom(p)
    changeset = change(user, params)
    changeset |> Matchup.Repo.update
  end

  defp insert(p) when is_map(p) do
    params = map_key_to_atom(p)
    changeset = change(%Matchup.Sf5_User{}, params)
    changeset |> Matchup.Repo.insert
  end

  defp map_key_to_atom(map) when is_map(map) do
    map |> Enum.reduce(%{}, fn({key, value}, ac) ->
      ac |> Map.put(String.to_atom(key), value)
    end)
  end
end
