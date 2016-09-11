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
    get "/users/:id", UsersController, :profile
    post "/users", UsersController, :create
    post "/users/update_game_profile", UsersController, :update_game_profile

    get "/lounge_now", LoungeController, :now_index
    post "/lounge_create_now", LoungeController, :create_now
  end

  # Other scopes may use custom stacks.
  # scope "/api", Matchup do
  #   pipe_through :api
  # end
end
