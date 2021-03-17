defmodule StockBookWeb.ArticleController do
  use StockBookWeb, :controller
  alias StockBook.Article.ArticleService

  plug :require_logged_in_user


  #Returns the list of articles for GET to /articles
  def index(conn, _params) do
    articles = ArticleService.list_articles()
    render(conn, "index.html", articles: articles)
  end

  def show(conn, %{"id" => id}) do
    article = ArticleService.get_article(id)
    render(conn, "show.html", article: article)
  end

  # Render form to create a new article for GET to /articles/new
  def new(conn, _params) do
    article = ArticleService.new_article()
    render(conn, "new.html", article: article)
  end

  # POST to /articles, saves a new article to the database
  def create(conn, %{"content" => content}) do
    user_id = conn.assigns.current_user.id

    case ArticleService.insert_article(%{content: content, user_id: user_id}) do
      {:ok, article} -> redirect(conn, to: Routes.article_path(conn, :show, article))
      {:error, article} -> render(conn, "new.html", article: article)
    end
  end

  # Throw an error if there if the current_user is nil
  defp require_logged_in_user(%{assigns: %{current_user: nil}} = conn, _opts) do
    conn
    |> put_flash(:error, "Nice try, friend. You must be logged in to create an article.")
    |> redirect(to: Routes.article_path(conn, :index))
    |> halt()
  end

  defp require_logged_in_user(conn, _opts), do: conn


end
