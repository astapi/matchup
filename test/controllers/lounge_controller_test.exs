defmodule Matchup.LoungenowControllerTest do
  use Matchup.ConnCase
  alias Matchup.User

  alias Matchup.Lounge_now
  alias Matchup.Repo

  setup_all do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Matchup.Repo)
    {:ok, user} = Repo.insert(%User{ name: "namae1", twitter_token: "token"  })
    {:ok, [user: user]}
  end

  test "GET /lounge_now", %{conn: conn} do
    conn = get conn, "/lounge_now"
    body = json_response(conn, 200)
    assert %{ "lounge_now_list" => [] } = body
  end

  test "GET /lounge_now with sort check", %{conn: conn, user: user} do
    params = %{user_id: user.id, character: "ryu", req_lp: 10000, 
     req_character: "ken", rule: 0,
     pass: "1234", comment: "yororo",
    }
    conn = post conn, "/lounge_create_now", params
    body = json_response(conn, 204)
    assert "" = body

    conn = get conn, "/lounge_now"
    body = json_response(conn, 200)

    user_id = user.id
    assert %{ "lounge_now_list" => [
        %{
          "id" => _, "user_id" => ^user_id,
          "character" => "ryu", "comment" => "yororo",
          "pass" => "1234",
          "req_character" => "ken", "req_lp" => 10000, "rule" => 0,
          "inserted_at" => _, "updated_at" => _
       }
      ] } = body
  end

  test "POST /lounge_create_now", %{conn: conn, user: user} do
    #conn = post conn, "/lounge_create_now", params
    params = %{user_id: user.id, character: "ryu", req_lp: 10000, 
     req_character: "ken", rule: 0,
     pass: "1234", comment: "yororo",
    }
    conn = post conn, "/lounge_create_now", params
    body = json_response(conn, 204)
    assert "" = body

    count = Lounge_now |> Repo.all |> Enum.count
    assert 1 = count
  end
end
