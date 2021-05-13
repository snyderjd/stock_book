defmodule StockBook.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string
    timestamps()
    belongs_to :user, StockBook.User
    belongs_to :article, StockBook.Article
  end

  def changeset(comment, params \\ %{}) do
    comment
    |> cast(params, [:content, :user_id, :article_id])
    |> validate_required([:content, :user_id, :article_id])
    |> validate_length(:content, min: 8)
  end
end
