defmodule StockBookWeb.CommentController do
  use StockBookWeb, :controller

  alias StockBook.Article.ArticleService
  alias StockBook.Comment.CommentService
  alias StockBookWeb.ArticleView

  plug :require_logged_in_user

  def create(conn, %{"comment" => %{"content" => content}, "article_id" => article_id}) do
    user_id = conn.assigns.current_user.id

    IO.inspect(content, label: "content")
    IO.inspect(user_id, label: "user_id")
    IO.inspect(article_id, label: "article_id")

    case CommentService.insert_comment(%{
           content: content,
           user_id: user_id,
           article_id: article_id
         }) do
      {:ok, comment} ->
        IO.inspect(comment, label: "comment")
        redirect(conn, to: Routes.article_path(conn, :show, article_id))

      {:error, comment} ->
        article = ArticleService.get_article(article_id)
        render(conn, ArticleView, "show.html", article: article, comment: comment)
    end
  end

  defp require_logged_in_user(%{assigns: %{current_user: nil}} = conn, _opts) do
    conn
    |> put_flash(:error, "Nice try, friend. You must be logged in to add comments.")
    |> redirect(to: Routes.article_path(conn, :index))
    |> halt()
  end

  defp require_logged_in_user(conn, _opts), do: conn
end
