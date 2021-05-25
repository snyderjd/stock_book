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

        render(conn, ArticleView, "show.html",
          article: article,
          comment: comment,
          updating_comment: false
        )
    end
  end

  @spec edit(Plug.Conn.t(), map) :: Plug.Conn.t()
  def edit(conn, %{"article_id" => article_id, "id" => id}) do
    article = ArticleService.get_article(article_id)
    comment_changeset = CommentService.edit_comment(id)
    comment = CommentService.get_comment(id)

    verify_author(conn, comment.user_id)

    conn
    |> put_view(StockBookWeb.ArticleView)
    |> render(:show,
      article: article,
      comment: comment_changeset,
      updating_comment: true,
      comment_id: id
    )
  end

  @spec update(Plug.Conn.t(), map) :: Plug.Conn.t()
  def update(conn, params = %{"id" => id}) do
    comment = CommentService.get_comment(id)
    article = ArticleService.get_article(comment.article_id)
    new_comment = CommentService.new_comment()

    verify_author(conn, comment.user_id)

    case CommentService.update_comment(id, params["comment"]) do
      {:ok, _comment} ->
        conn
        |> put_view(StockBookWeb.ArticleView)
        |> redirect(
          to: Routes.article_path(conn, :show, article),
          article: article,
          comment: new_comment,
          updating_comment: false
        )

      {:error, comment} ->
        render(conn, ArticleView, "show.html",
          article: article,
          comment: comment,
          updating_comment: true,
          comment_id: id
        )
    end
  end

  @spec delete(Plug.Conn.t(), map) :: Plug.Conn.t()
  def delete(conn, _params = %{"id" => id}) do
    comment = CommentService.get_comment(id)
    article = ArticleService.get_article(comment.article_id)
    new_comment = CommentService.new_comment()

    verify_author(conn, comment.user_id)

    case CommentService.delete_comment(id) do
      {:ok, _comment} ->
        conn
        |> put_view(StockBookWeb.ArticleView)
        |> put_flash(:info, "Comment deleted successfully")
        |> redirect(
          to: Routes.article_path(conn, :show, article),
          article: article,
          comment: new_comment,
          updating_comment: false
        )

      {:error, _comment} ->
        conn
        |> put_view(StockBookWeb.ArticleView)
        |> render("show.html", article: article, comment: new_comment, updating_comment: false)
    end
  end

  ########## PRIVATE ##########

  defp require_logged_in_user(%{assigns: %{current_user: nil}} = conn, _opts) do
    conn
    |> put_flash(:error, "Nice try, friend. You must be logged in to add comments.")
    |> redirect(to: Routes.article_path(conn, :index))
    |> halt()
  end

  defp require_logged_in_user(conn, _opts), do: conn

  defp verify_author(conn, author_id) do
    if conn.assigns.current_user.id != author_id do
      conn
      |> put_flash(:error, "You do not have permission to edit this comment.")
      |> redirect(to: Routes.article_path(conn, :index))
      |> halt()
    end
  end
end
