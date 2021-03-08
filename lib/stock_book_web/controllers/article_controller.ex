defmodule StockBookWeb.ArticleController do
  use StockBookWeb, :controller
  alias StockBook.Article.ArticleService

  # Render form to create a new article for GET to /articles/new
  def new(conn, _params) do
    article = ArticleService.new_article()
    render(conn, "new.html", article: article)
  end


end
