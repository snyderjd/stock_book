defmodule StockBookWeb.UserController do
  use StockBookWeb, :controller

  alias StockBook.User.UserService
  plug :prevent_unauthorized_access when action in [:show]

  # Gets a user by their id and renders the show template
  def show(conn, %{"id" => id}) do
    user = UserService.get_user(id)
    render(conn, "show.html", user: user)
  end

  # Creates a user changeset and passes it to the template for a new user
  def new(conn, _params) do
    user = UserService.new_user()
    render(conn, "new.html", user: user)
  end

  # Takes in user params and creates a new user. If successful, redirects
  # to the new user's detail page. If not, re-renders the new form with errors
  def create(conn, %{"user" => user_params}) do
    case UserService.insert_user(user_params) do
      {:ok, user} -> redirect(conn, to: Routes.user_path(conn, :show, user))
      {:error, user} -> render(conn, "new.html", user: user)
    end
  end

  defp prevent_unauthorized_access(conn, _opts) do
    current_user = Map.get(conn.assigns, :current_user)

    requested_user_id =
      conn.params
      |> Map.get("id")
      |> String.to_integer()

    if current_user == nil || current_user.id != requested_user_id do
      conn
      |> put_flash(:error, "Nice try, friend. That's not a page for you.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    else
      conn
    end
  end

end
