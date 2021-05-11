defmodule StockBook.Article.ArticleService do
  @moduledoc """
  Provides a set of public interface functions for articles that allow you to
  easily create, read, update, etc.
  """
  alias StockBook.{Article, Comment, Repo}

  @spec list_articles :: nil | [%{optional(atom) => any}] | %{optional(atom) => any}
  def list_articles do
    Repo.all(Article)
    |> Repo.preload(:user)
  end

  @spec get_article(any) :: nil | [%{optional(atom) => any}] | %{optional(atom) => any}
  def get_article(id) do
    Article
    |> Repo.get!(id)
    |> Repo.preload(:user)
  end

  @spec get_article_by(any) :: any
  def get_article_by(attrs) do
    Repo.get_by(Article, attrs)
  end

  @spec new_article :: Ecto.Changeset.t()
  def new_article, do: Article.changeset(%Article{})

  @spec insert_article(map()) :: any
  def insert_article(attrs) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  @spec edit_article(any) :: Ecto.Changeset.t()
  def edit_article(id) do
    get_article(id)
    |> Article.changeset()
  end

  @spec update_article(any, map()) :: any
  def update_article(%Article{} = article, updates) do
    article
    |> Article.changeset(updates)
    |> Repo.update()
  end

  @spec delete_article(any) :: any
  def delete_article(id) do
    get_article(id)
    |> Article.changeset()
    |> Repo.delete()
  end
end
