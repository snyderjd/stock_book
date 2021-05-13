defmodule StockBook.Repo.Migrations.UpdateCommentsTable do
  use Ecto.Migration

  def change do
    drop unique_index(:comments, :user_id)
    drop unique_index(:comments, :article_id)

    create index(:comments, :user_id)
    create index(:comments, :article_id)
  end
end
