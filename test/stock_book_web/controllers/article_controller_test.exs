defmodule StockBookWeb.ArticleControllerTest do
  # Testing Controllers
  # hexdocs.pm/phoenix/testing_controllers.html#content

    use StockBookWeb.ConnCase
    use Phoenix.ConnTest

    alias StockBook.{Article, Repo, User}
    alias StockBook.Article.ArticleService
    alias StockBook.User.UserService

    @create_attrs %{content: "article content goes here", title: "new article title"}
    @invalid_attrs %{content: "", title: ""}

    describe "index" do
      setup %{conn: conn} do
        user1 = UserService.get_user(1)
        user2 = UserService.get_user(2)

        # Insert some test articles
        {:ok, article1} = Repo.insert(%Article{title: "Article 1", content: "Article 1 content", user_id: user1.id})
        {:ok, article2} = Repo.insert(%Article{title: "Article 2", content: "Article 2 content", user_id: user1.id})
        {:ok, article3} = Repo.insert(%Article{title: "Article 4", content: "Article 4 content", user_id: user2.id})

        # Update the connection to authenticate a user
        updated_conn =
          conn
          |> post("/login", %{"user" => %{"email" => "joe_snyder@test.com", "password" => "password1"}})

        %{conn: updated_conn, articles: [article1, article2, article3]}
      end

      test "lists all the articles", %{conn: conn} do
        new_conn = get(conn, Routes.article_path(conn, :index))
        assert html_response(new_conn, 200) =~ "Articles"
      end
    end

    describe "show" do
      setup %{conn: conn} do
        user = UserService.get_user(1)
        {:ok, article} = Repo.insert(%Article{title: "Article 1",
                                              content: "Article 1 content",
                                              user_id: user.id})

        # Update the connection to authenticate a user
        updated_conn =
          conn
          |> post("/login", %{"user" => %{"email" => "joe_snyder@test.com", "password" => "password1"}})

        %{conn: updated_conn, article: article}
      end

      test "gets an article by its id", %{conn: conn, article: article} do
        new_conn = get(conn, Routes.article_path(conn, :show, article.id))
        assert html_response(new_conn, 200) =~ article.title
      end
    end

    describe "new" do
      setup %{conn: conn} do
        # Update the connection to authenticate a user
        updated_conn =
          conn
          |> post("/login", %{"user" => %{"email" => "joe_snyder@test.com", "password" => "password1"}})

        %{conn: updated_conn}
      end

      test "returns form to input a new article", %{conn: conn} do
        new_conn = get(conn, Routes.article_path(conn, :new))
        assert html_response(new_conn, 200) =~ "New Article"
      end
    end

    describe "create article" do
      setup %{conn: conn} do
        conn =
          conn
          |> post("/login", %{"user" => %{"email" => "joe_snyder@test.com", "password" => "password1"}})

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
        user1 = UserService.get_user(1)
        user2 = UserService.get_user(2)

        # Insert some test articles
        {:ok, article1} = Repo.insert(%Article{title: "Article 1", content: "Article 1 content", user_id: user1.id})
        {:ok, article2} = Repo.insert(%Article{title: "Article 2", content: "Article 2 content", user_id: user1.id})

        # Make sure the article's author is authenticated
        conn =
          conn
          |> post("/login", %{"user" => %{"email" => "joe_snyder@test.com", "password" => "password1"}})

        {:ok, conn: conn, articles: [article1, article2]}
      end

      test "edit returns form with article info", %{conn: conn, articles: [article1, article2]} do
        conn = get(conn, Routes.article_path(conn, :edit, article1.id))
        assert html_response(conn, 200) =~ article1.title
      end

      # Not having any luck getting the app to recognize the test article's data?
      # Look into setting up ex machina for more reliable test data?

      # test "user can't edit another user's article", %{conn: conn, articles: [article1, article2]} do
      #   conn = get(conn, Routes.article_path(conn, :edit, article2.id))
      #   assert html_response(conn, 200)
      #   IO.inspect(conn, label: "conn after request")
      # end

    end

end
