defmodule Matchup.User do
  use Ecto.Schema
  alias Matchup.Digest
  alias Matchup.Repo

  require Ecto.Query

  @derive {Poison.Encoder, only: [
    :id, :name, :twitter_token, :auth_token, :inserted_at, :updated_at
  ]}

  schema "users" do
    field :name, :string
    field :twitter_token, :string
    field :auth_token, :string
    timestamps
  end

  def create(%{"name" => name, "twitter_token" => token}) do
    auth_token = token |> Digest.sha256
    Matchup.Repo.insert(%Matchup.User{ name: name, twitter_token: token, auth_token: auth_token })
  end

  def from_auth_token(auth_token) when is_binary auth_token do
    Matchup.User |> Ecto.Query.where(auth_token: ^auth_token) |> Repo.one
  end

  def from_user_id_with_game_profile(user_id) when is_integer user_id do
    case Matchup.User |> Ecto.Query.where(id: ^user_id) |> Repo.one do
      nil -> nil
        #TODO erorr
      user ->
        all_profile(user)
    end
  end

  defp all_profile(user) do
    # TODO game profileをすべてつなげる
    user
  end
end
