defmodule StockBook.Repo.Migrations.UpdateArticlesTable do
  use Ecto.Migration

  def change do
    drop unique_index(:articles, :user_id)
    create index(:articles, :user_id)
  end
end
