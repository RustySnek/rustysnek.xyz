defmodule RustysnekWeb.Router do
  use RustysnekWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RustysnekWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RustysnekWeb do
    pipe_through :browser
    live "/", Index
    live "/venomous", Snakes
    live "/elixirus", Elixirus
    live "/librus-apix", LibrusApix
    live "/kotkowo", Kotkowo
  end

  # Other scopes may use custom stacks.
  # scope "/api", RustysnekWeb do
  #   pipe_through :api
  # end
end
