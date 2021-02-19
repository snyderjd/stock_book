defmodule StockBook.Repo.Migrations.InitialMigration do
  use Ecto.Migration

  def change do
    create table("users") do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :hashed_password, :string
      timestamps()
    end

    create table("articles") do
      add :content, :text
      add :user_id, references(:users)
      timestamps()
    end

    create_unique_index(:articles, :user_id)

    create table("comments") do
      add :content, :string
      add :user_id, references(:users)
      add :article_id, references(:articles)
      timestamps()
    end

    create_unique_index(:comments, :user_id)
    create_unique_index(:comments, :article_id)

    create table("likes") do
      add :user_id, references(:users)
      add :article_id, references(:articles)
      timestamps()
    end

    create_unique_index(:likes, :user_id)
    create_unique_index(:likes, :article_id)
  end

end
