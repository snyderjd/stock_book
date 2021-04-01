defmodule StockBookWeb.Router do
  use StockBookWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug StockBookWeb.Authenticator
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StockBookWeb do
    pipe_through :browser

    # Routes for loggin in, creating, or deleting a session
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete

    get "/", PageController, :index
    resources "/users", UserController, only: [:show, :new, :create]
    resources "/articles", ArticleController, only: [:new, :create, :index, :show, :edit, :update, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", StockBookWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: StockBookWeb.Telemetry
    end
  end
end
