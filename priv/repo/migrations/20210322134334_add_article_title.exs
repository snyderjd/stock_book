defmodule StockBook.Repo.Migrations.AddArticleTitle do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :title, :string, null: false, default: "Title Placeholder"
    end
  end
end
