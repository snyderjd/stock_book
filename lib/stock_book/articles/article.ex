defmodule StockBook.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles" do
    field :content, :string
    timestamps()
    belongs_to :user, StockBook.User
    has_many :comments, StockBook.Comment
    has_many :likes, StockBook.Like
  end

  def changeset(article, params \\ %{}) do
    article
    |> cast(params, [:content, :user_id])
    |> validate_required([:content, :user_id])
    |> assoc_constraint(:user)
  end
end
