defmodule Matchup.Router do
  use Matchup.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Matchup do
    #pipe_through :browser # Use the default browser stack
    pipe_through :api # Use the default browser stack

    get "/users", UsersController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Matchup do
  #   pipe_through :api
  # end
end
