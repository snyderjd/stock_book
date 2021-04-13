defmodule StockBookWeb.ArticleControllerTest do
    use StockBookWeb.ConnCase
    use Phoenix.ConnTest

    alias StockBook.{Article, Repo, User}

    setup %{conn: conn} do

      # Insert user and articles by that user
      {:ok, user1} = Repo.insert(%User{id: 2, first_name: "Ray", last_name: "Dalio", email: "ray_dalio@test.com", password: "password1"})

      {:ok, article1} = Repo.insert(%Article{title: "Article 1", content: "Article 1 content", user_id: user1.id})
      {:ok, article2} = Repo.insert(%Article{title: "Article 2", content: "Article 2 content", user_id: user1.id})
      {:ok, article3} = Repo.insert(%Article{title: "Article 3", content: "Article 3 content", user_id: user1.id})

      # Update the connection to authenticate a user
      updated_conn =
        conn
        |> post("/login", %{"user" => %{"email" => "joe_snyder@test.com", "password" => "password1"}})

      %{conn: updated_conn, articles: [article1, article2, article3]}
    end

    describe "index" do
      test "lists all the articles", %{conn: conn} do
        new_conn = get(conn, Routes.article_path(conn, :index))
        assert html_response(new_conn, 200) =~ "Articles"
      end
    end

    describe "show" do
      test "gets an article by its id", %{conn: conn, articles: [article1, _article2, _article3]} do
        new_conn = get(conn, Routes.article_path(conn, :show, article1.id))
        assert html_response(new_conn, 200) =~ article1.title
      end
    end

    describe "new" do
      test "returns form to input a new article", %{conn: conn} do
        new_conn = get(conn, Routes.article_path(conn, :new))
        assert html_response(new_conn, 200) =~ "New Article"
      end
    end





end
