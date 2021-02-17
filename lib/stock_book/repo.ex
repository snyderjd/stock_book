defmodule StockBook.Repo do
  use Ecto.Repo,
    otp_app: :stock_book,
    adapter: Ecto.Adapters.Postgres
end
