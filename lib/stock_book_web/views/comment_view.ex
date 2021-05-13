defmodule StockBookWeb.CommentView do
  use StockBookWeb, :view

  @spec formatted_date(any()) :: any
  def formatted_date(date) do
    date
    |> Timex.format!("{YYYY}-{M}-{D} {h24}:{m}")
  end

  @spec get_full_name(any()) :: any
  def get_full_name(author) do
    "#{author.first_name} #{author.last_name}"
  end
end
