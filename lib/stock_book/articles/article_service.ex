defmodule StockBook.Article.ArticleService do
  @moduledoc """
  Provides a set of public interface functions for articles that allow you to
  easily create, read, update, etc.
  """
  alias StockBook.{Article}
  @repo StockBook.Repo

  def list_articles do
    @repo.all(Article)
    |> @repo.preload(:user)
  end

  def get_article(id) do
    Article
    |> @repo.get!(id)
    |> @repo.preload(:user)
  end

  def get_article_by(attrs) do
    @repo.get_by(Article, attrs)
  end

  def new_article, do: Article.changeset(%Article{})

  def insert_article(attrs) do
    %Article{}
    |> Article.changeset(attrs)
    |> @repo.insert()
  end

  def edit_article(id) do
    get_article(id)
    |> Article.changeset()
  end

  def update_article(%Article{} = article, updates) do
    article
    |> Article.changeset(updates)
    |> @repo.update()
  end

end
