defmodule StockBook.Comment.CommentService do
  @moduledoc """
  Provides a set of public interface functions for comments
  that allow you to easily create, read, update, etc.
  """

  alias StockBook.{Comment, Repo}

  @spec get_comment(any) :: Comment
  def get_comment(id) do
    Comment
    |> Repo.get!(id)
    |> Repo.preload([:user])
  end

  @spec new_comment :: Ecto.Changeset.t()
  def new_comment, do: Comment.changeset(%Comment{})

  @spec edit_comment(any) :: Ecto.Changeset.t()
  def edit_comment(id) do
    get_comment(id)
    |> Comment.changeset()
  end

  @spec insert_comment(map()) :: tuple()
  def insert_comment(params) do
    %Comment{}
    |> Comment.changeset(params)
    |> Repo.insert()
  end
end
