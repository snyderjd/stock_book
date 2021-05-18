defmodule StockBookWeb.ArticleView do
  use StockBookWeb, :view
  use Timex

  def formatted_date(date) do
    date
    |> Timex.format!("{YYYY}-{M}-{D}")
  end

  def get_full_name(author) do
    "#{author.first_name} #{author.last_name}"
  end

  def article_index_display(article) do
    "#{article.title} | #{article.user.first_name} #{article.user.last_name} | #{
      article.inserted_at
    }"
  end

end
