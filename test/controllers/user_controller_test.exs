defmodule Matchup.UserControllerTest do
  use Matchup.ConnCase
  alias Matchup.User
  alias Matchup.Digest
  require Poison

  test "GET /users", %{conn: conn} do
    conn = get conn, "/users"
    body = json_response(conn, 200)
    assert %{ "users" => [] } = body
  end

  test "GET /users with one user", %{conn: conn} do
    {:ok, user} = Repo.insert(%User{ name: "namae", twitter_token: "token"  })
    conn = get conn, "/users"
    body = json_response(conn, 200)
    {:ok, json_user} = Poison.encode!(user) |> Poison.decode
    assert %{ "users" => [^json_user] } = body
  end

  test "POST /users", %{conn: conn} do
    conn = post conn, "/users", %{ name: "namae", twitter_token: "token" }
    body = json_response(conn, 201)
    auth_token = Digest.sha256("token")
    assert %{ "user" => %{
        "name" => "namae", "twitter_token" => "token",
        "auth_token" => ^auth_token,
        "id" => _, "inserted_at" => _, "updated_at" => _
      }
    } = body
  end

  test "POST /users/update_game_profile game sf5 insert & update", %{conn: conn} do
    {:ok, user} = User.create(%{ "name" => "namae", "twitter_token" => "token" })
    prof = %{ "game_id" => "hogehoge", "lp" => 14000, "character" => "ryu" }
    params = %{} |> Map.merge(%{"auth_token" => user.auth_token,
      "game" => "sf5", "profile" => prof})
    conn = post conn, "/users/update_game_profile", params
    body = json_response(conn, 201)
    user_id = user.id
    assert %{ "sf5_user" => %{
        "user_id" => ^user_id, "game_id" => "hogehoge",
        "lp" => 14000, "character" => "ryu"
      }
    }= body

    prof = %{ "game_id" => "hogehoge", "lp" => 20000, "character" => "ryu" }
    params = %{} |> Map.merge(%{"auth_token" => user.auth_token,
      "game" => "sf5", "profile" => prof})
    conn = post conn, "/users/update_game_profile", params
    body = json_response(conn, 201)
    user_id = user.id
    assert %{ "sf5_user" => %{
        "user_id" => ^user_id, "game_id" => "hogehoge",
        "lp" => 20000, "character" => "ryu"
      }
    }= body
  end

  test "POST /users/update_game_profile user unauthorized", %{conn: conn} do
    prof = %{ "game_id" => "hogehoge", "lp" => 14000, "character" => "ryu" }
    params = %{} |> Map.merge(%{"auth_token" => "not token string",
      "game" => "sf5", "profile" => prof})
    conn = post conn, "/users/update_game_profile", params
    body = json_response(conn, 401)
    assert "unauthorized" = body
  end

end
