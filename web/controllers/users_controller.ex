defmodule Matchup.UsersController do
  use Matchup.Web, :controller
  alias Matchup.User
  alias Matchup.Sf5_User

  require Logger

  def index(conn, _params) do
    json conn, %{ users: User |> Repo.all }
  end

  def profile(conn, %{ "id" => user_id }) when is_integer user_id do
    json conn, User.from_user_id_with_game_profile(user_id)
  end

  def create(conn, params = %{ "name" => _name, "twitter_token" => _token }) do
    {:ok, user} = User.create(params)
    conn |> put_status(:created) |> json(%{ user: user })
  end

  def update_game_profile(conn, params = %{ "auth_token" => token, "game" => "sf5", "profile" => _prof}) do
    case token |> User.from_auth_token do
      nil -> conn |> put_status(:unauthorized) |> json("unauthorized")
      user ->
        {:ok, sf5_user} = params["profile"] |> Map.put("user_id", user.id)
        |> Sf5_User.update_or_insert
        conn |> put_status(:created) |> json(%{ sf5_user: sf5_user })
    end
  end
end
