defmodule StockBookWeb.ArticleControllerTest do
  # Testing Controllers
  # hexdocs.pm/phoenix/testing_controllers.html#content

  use StockBookWeb.ConnCase

  import Phoenix.ConnTest
  import StockBook.Factory

  @create_attrs %{content: "article content goes here", title: "new article title"}
  @invalid_attrs %{content: "", title: ""}

  describe "index" do
    setup %{conn: conn} do
      # Insert some test articles
      article1 = insert(:article)
      article2 = insert(:article)
      article3 = insert(:article)

      user = insert(:user)

      # Update the connection to authenticate a user
      conn =
        conn
        |> post("/login", %{"user" => %{"email" => user.email, "password" => user.password}})

      %{conn: conn, articles: [article1, article2, article3]}
    end

    test "lists all the articles", %{conn: conn} do
      new_conn = get(conn, Routes.article_path(conn, :index))
      assert html_response(new_conn, 200) =~ "Articles"
    end
  end

  describe "show" do
    setup %{conn: conn} do
      # Insert a test article and user
      comment1 = build(:comment_without_article)
      comment2 = build(:comment_without_article)
      article = insert(:article, comments: [comment1, comment2])
      user = insert(:user)

      # Update the connection to authenticate a user
      conn =
        conn
        |> post("/login", %{"user" => %{"email" => user.email, "password" => user.password}})

      %{conn: conn, article: article, comments: [comment1, comment2]}
    end

    test "gets an article by its id", %{
      conn: conn,
      article: article,
      comments: [comment1, comment2]
    } do
      conn = get(conn, Routes.article_path(conn, :show, article.id))
      assert html_response(conn, 200) =~ article.title
      assert html_response(conn, 200) =~ comment1.content
      assert html_response(conn, 200) =~ comment2.content
    end
  end

  describe "new" do
    setup %{conn: conn} do
      user = insert(:user)

      # Update the connection to authenticate a user
      conn =
        conn
        |> post("/login", %{"user" => %{"email" => user.email, "password" => user.password}})

      %{conn: conn}
    end

    test "returns form to input a new article", %{conn: conn} do
      new_conn = get(conn, Routes.article_path(conn, :new))
      assert html_response(new_conn, 200) =~ "New Article"
    end
  end

  describe "create article" do
    setup %{conn: conn} do
      user = insert(:user)

      # Authenticate (login) a user
      conn =
        conn
        |> post("/login", %{"user" => %{"email" => user.email, "password" => user.password}})

      {:ok, conn: conn}
    end

    test "Creates article and redirects to show page when data is valid", %{conn: conn} do
      conn = post(conn, Routes.article_path(conn, :create), @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.article_path(conn, :show, id)

      conn = get(conn, Routes.article_path(conn, :show, id))
      assert html_response(conn, 200) =~ "new article title"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.article_path(conn, :create), @invalid_attrs)
      assert html_response(conn, 200) =~ "New Article"
    end
  end

  describe "edit and update article" do
    setup %{conn: conn} do
      user1 = insert(:user)
      user2 = insert(:user)

      # Insert some test articles
      article1 = insert(:article, user: user1)
      article2 = insert(:article, user: user2)

      # Make sure the article's author is authenticated
      conn =
        conn
        |> post("/login", %{"user" => %{"email" => user1.email, "password" => user1.password}})

      {:ok, conn: conn, articles: [article1, article2]}
    end

    test "edit returns form with article info", %{conn: conn, articles: [article1, _article2]} do
      conn = get(conn, Routes.article_path(conn, :edit, article1.id))
      assert html_response(conn, 200) =~ article1.title
    end

    test "user can update their article", %{conn: conn, articles: [article1, _article2]} do
      article_params = %{
        id: article1.id,
        content: "Updated article content",
        title: "Updated article title"
      }

      conn = put(conn, Routes.article_path(conn, :update, article1.id, article_params))
      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.article_path(conn, :show, id)
    end
  end

  describe "delete article" do
    setup %{conn: conn} do
      user = insert(:user)
      article = insert(:article, user: user)

      # Authenticate the user
      conn =
        conn
        |> post("/login", %{"user" => %{"email" => user.email, "password" => user.password}})

      {:ok, conn: conn, article: article}
    end

    test "user can delete their own article", %{conn: conn, article: article} do
      conn = delete(conn, Routes.article_path(conn, :delete, article.id))
      assert redirected_to(conn) == Routes.article_path(conn, :index)
    end
  end
end
