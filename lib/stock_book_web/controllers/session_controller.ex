defmodule StockBookWeb.SessionController do
  use StockBookWeb, :controller

  # Renders the new template for a session (login form)
  def new(conn, _params) do
    render(conn, "new.html")
  end

  # Look up username and password. If found, store user_id in the session to create a new session
  # If not found, display error message and re-render the login form
  def create(conn, %{"user" => %{"username" => username, "password" => password}}) do
    # Abstract repo interactions in stock_book to "service" files?
    # (i.e. - user_service.ex handles getting, creating, updating users, etc.)
    # How to structure?
  end

end
