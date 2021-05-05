defmodule StockBook.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: StockBook.Repo
  alias StockBook.Password

  def user_factory do
    first_name = Faker.Person.first_name()
    last_name = Faker.Person.last_name()

    %StockBook.User{
      first_name: first_name,
      last_name: last_name,
      email: "#{first_name}_#{last_name}@test.com",
      password: "password1",
      hashed_password: Password.hash("password1")
    }
  end

  def article_factory do
    %StockBook.Article{
      title: Faker.Lorem.word(),
      content: Faker.Lorem.paragraph(),
      user: build(:user)
    }
  end
end
