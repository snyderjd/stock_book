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

      IO.inspect(html_response(conn, 200), label: "response")

      conn = get(conn, Routes.article_path(conn, :show, article.id))
      assert html_response(conn, 200) =~ article.title
      assert response(conn, 200) =~ "There are errors in your submission. Please correct them below."
    end

    # assert %{id: id} = redirected_params(conn)
    # assert redirected_to(conn) == Routes.article_path(conn, :show, id)

    # conn = get(conn, Routes.article_path(conn, :show, id))
    # assert html_response(conn, 200) =~ "new article title"
  end

end

# describe "show" do
#   setup %{conn: conn} do
#     # Insert a test article and user
#     comment1 = build(:comment_without_article)
#     comment2 = build(:comment_without_article)
#     article = insert(:article, comments: [comment1, comment2])
#     user = insert(:user)

#     # Update the connection to authenticate a user
#     conn =
#       conn
#       |> post("/login", %{"user" => %{"email" => user.email, "password" => user.password}})

#     %{conn: conn, article: article, comments: [comment1, comment2]}
#   end

#   test "gets an article by its id", %{conn: conn, article: article, comments: [comment1, comment2]} do
#     conn = get(conn, Routes.article_path(conn, :show, article.id))
#     assert html_response(conn, 200) =~ article.title
#     assert html_response(conn, 200) =~ comment1.content
#     assert html_response(conn, 200) =~ comment2.content
#   end
# end
