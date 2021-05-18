defmodule StockBookWeb.CommentController do
  use StockBookWeb, :controller

  alias StockBook.Article.ArticleService
  alias StockBook.Comment.CommentService
  alias StockBookWeb.ArticleView

  plug :require_logged_in_user

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"comment" => %{"content" => content}, "article_id" => article_id}) do
    user_id = conn.assigns.current_user.id

    case CommentService.insert_comment(%{
           content: content,
           user_id: user_id,
           article_id: article_id
         }) do
      {:ok, _comment} ->
        redirect(conn, to: Routes.article_path(conn, :show, article_id))

      {:error, comment} ->
        article = ArticleService.get_article(article_id)
        render(conn, ArticleView, "show.html", article: article, comment: comment)
    end
  end

  @spec edit(Plug.Conn.t(), map) :: Plug.Conn.t()
  def edit(conn, %{"article_id" => article_id, "id" => id}) do
    article = ArticleService.get_article(article_id)
    comment = CommentService.edit_comment(id)

    conn
    |> put_view(StockBookWeb.ArticleView)
    |> render(:show, article: article, comment: comment, updating_comment: true, comment_id: id)
  end

  @spec update(Plug.Conn.t(), map) :: Plug.Conn.t()
  def update(conn, params = %{"id" => id}) do
    IO.inspect(conn, label: "conn")
    IO.inspect(params, label: "params")
  end

  ########## PRIVATE ##########

  defp require_logged_in_user(%{assigns: %{current_user: nil}} = conn, _opts) do
    conn
    |> put_flash(:error, "Nice try, friend. You must be logged in to add comments.")
    |> redirect(to: Routes.article_path(conn, :index))
    |> halt()
  end

  defp require_logged_in_user(conn, _opts), do: conn
end
