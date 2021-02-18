defmodule StockBook.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    timestamps()
    has_many :articles, Auction.Article
    has_many :comments, Auction.Comment
    has_many :likes, Auction.Like
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:first_name, :last_name, :email])
    |> validate_required([:first_name, :last_name, :email, :hashed_password])
  end

  def changeset_with_password(user, params \\ %{}) do
    user
    |> cast(params, [:password])
    |> validate_required(:password)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password, required: true)
    |> hash_password()
    |> changeset(params)
  end

  defp hash_password(%Ecto.Changeset{changes: %{password: password}} = changeset) do
    changeset
    |> put_change(:hashed_password, StockBook.Password.hash(password))
  end

  defp hash_password(changeset), do: changeset
end
