defmodule StockBook.User.UserService do
  @moduledoc """
  Provides a set of public interface functions that allow you to
  easily create, read, update, delete users, etc.
  """

  alias StockBook.{Password, User}
  import Ecto.Query

  @repo StockBook.Repo

  def get_user(id), do: @repo.get!(User, id)

  def new_user, do: User.changeset_with_password(%User{})

  def insert_user(params) do
    %User{}
    |> User.changeset_with_password(params)
    |> @repo.insert
  end

  def get_user_by_email_and_password(email, password) do
    with user when not is_nil(user) <- @repo.get_by(User, %{email: email}),
      true <- Password.verify_with_hash(password, user.hashed_password) do
        user
    else
      _ -> Password.dummy_verify()
    end
  end

end
