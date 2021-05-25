defmodule StockBookWeb.CommentControllerTest do
  # Testing Controllers
  # hexdocs.pm/phoenix/testing_controllers.html#content

  use StockBookWeb.ConnCase

  import Phoenix.ConnTest
  import StockBook.Factory

  describe "create" do
    setup %{conn: conn} do
      article = insert(:article)
      user = insert(:user)

      # Authenticate the user and add to assigns as current user
      conn =
        conn
        |> post("/login", %{"user" => %{"email" => user.email, "password" => user.password}})
        |> Map.put(:assigns, %{current_user: user})

      {:ok, conn: conn, article: article}
    end

    test "user can create a comment with valid params", %{conn: conn, article: article} do
      params = %{
        "comment" => %{"content" => "Morbi vel massa sed quam mollis"},
        "article_id" => article.id
      }

      # Make request to the article_comment_path to create an article with the correct params
      conn = post(conn, Routes.article_comment_path(conn, :create, article), params)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.article_path(conn, :show, id)

      conn = get(conn, Routes.article_path(conn, :show, id))
      assert html_response(conn, 200) =~ article.title
      assert html_response(conn, 200) =~ "Morbi vel massa sed quam mollis"
    end

    test "can't create a comment with invalid params", %{conn: conn, article: article} do
      invalid_params = %{
        "comment" => %{"content" => ""},
        "article_id" => article.id
      }

      conn = post(conn, Routes.article_comment_path(conn, :create, article), invalid_params)

      assert html_response(conn, 200) =~ article.title

      assert response(conn, 200) =~
               "There are errors in your submission. Please correct them below."
    end
  end

  describe "edit and update" do
    setup %{conn: conn} do
      article = insert(:article)
      user = insert(:user)

      # Authenticate the user and add to assigns as current user
      conn =
        conn
        |> post("/login", %{"user" => %{"email" => user.email, "password" => user.password}})
        |> Map.put(:assigns, %{current_user: user})

      comment = insert(:comment, article: article, user: user)

      {:ok, conn: conn, article: article, comment: comment}
    end

    test "User can make edit request for form to edit a comment", %{
      conn: conn,
      article: article,
      comment: comment
    } do
      conn = get(conn, Routes.article_comment_path(conn, :edit, article, comment))
      assert html_response(conn, 200) =~ article.title
    end

    test "User can update comment with valid params", %{
      conn: conn,
      article: article,
      comment: comment
    } do
      params = %{
        "article_id" => article.id,
        "comment" => %{"content" => "Lets update a comment"},
        "id" => comment.id
      }

      conn = put(conn, Routes.article_comment_path(conn, :update, article, comment), params)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.article_path(conn, :show, id)

      conn = get(conn, Routes.article_path(conn, :show, id))
      assert html_response(conn, 200) =~ article.title
      assert html_response(conn, 200) =~ "Lets update a comment"
    end

    test "User cannot update a comment with invalid params", %{
      conn: conn,
      article: article,
      comment: comment
    } do
      params = %{
        "article_id" => article.id,
        "comment" => %{"content" => ""},
        "id" => comment.id
      }

      conn = put(conn, Routes.article_comment_path(conn, :update, article, comment), params)

      assert html_response(conn, 200) =~ article.title

      assert html_response(conn, 200) =~
               "There are errors in your submission. Please correct them below."
    end
  end

  describe "delete" do
    setup %{conn: conn} do
      article = insert(:article)
      user = insert(:user)

      # Authenticate the user and add to assigns as current user
      conn =
        conn
        |> post("/login", %{"user" => %{"email" => user.email, "password" => user.password}})
        |> Map.put(:assigns, %{current_user: user})

      comment = insert(:comment, article: article, user: user)

      {:ok, conn: conn, article: article, comment: comment}
    end

    test "User can delete their comment", %{conn: conn, article: article, comment: comment} do
      conn = delete(conn, Routes.article_comment_path(conn, :delete, article, comment))

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.article_path(conn, :show, id)

      conn = get(conn, Routes.article_path(conn, :show, id))
      assert html_response(conn, 200) =~ article.title
      refute html_response(conn, 200) =~ comment.content
    end
  end
end
