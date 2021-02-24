defmodule StockBook.Like do
  use Ecto.Schema

  schema "likes" do
    timestamps()
    belongs_to :user, StockBook.User
    belongs_to :article, StockBook.Article
  end
end
