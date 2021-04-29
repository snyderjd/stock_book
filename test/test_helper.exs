# This helper will be executed before every test run. You can put any setup code you
# need to run before your tests in this file

Faker.start()
{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(StockBook.Repo, :manual)
