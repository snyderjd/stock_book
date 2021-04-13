# This helper will be executed before every test run. You can put any setup code you
# need to run before your tests in this file

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(StockBook.Repo, :manual)
