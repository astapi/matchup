defmodule Matchup.PageController do
  use Matchup.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
