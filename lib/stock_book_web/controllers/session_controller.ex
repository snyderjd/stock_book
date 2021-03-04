defmodule StockBookWeb.SessionController do
  use StockBookWeb, :controller
  alias StockBook.User.UserService

  # Renders the new template for a session (login form)
  def new(conn, _params) do
    render(conn, "new.html")
  end

  # Look up username and password. If found, store user_id in the session to create a new session
  # If not found, display error message and re-render the login form
  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case UserService.get_user_by_email_and_password(email, password) do
      %StockBook.User{} = user ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Successfully logged in")
        |> redirect(to: Routes.user_path(conn, :show, user))
      _ ->
        conn
        |> put_flash(:error, "That username and password combination cannot be found")
        |> render("new.html")
    end
  end

  # Logs out the current user (deletes the session)
  def delete(conn, _params) do
    conn
    |> clear_session()
    |> configure_session(drop: true)
    |> redirect(to: Routes.page_path(conn, :index))
  end

end
