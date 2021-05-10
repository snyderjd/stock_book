defmodule StockBook.Comment.CommentService do
  @moduledoc """
  Provides a set of public interface functions for comments
  that allow you to easily create, read, update, etc.
  """

  alias StockBook.{Comment}

  @spec new_comment :: Ecto.Changeset.t()
  def new_comment, do: Comment.changeset(%Comment{})

end
