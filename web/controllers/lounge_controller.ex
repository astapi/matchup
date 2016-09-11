defmodule Matchup.LoungeController do
  use Matchup.Web, :controller
  alias Matchup.Lounge_now

  def now_index(conn, _params) do
    json conn, %{ lounge_now_list: Lounge_now.list_lounge }
  end

  def create_now(conn, params) do
    {:ok, _lounge} = Lounge_now.create(params)
    conn |> put_status(:no_content) |> json("")
  end
end
