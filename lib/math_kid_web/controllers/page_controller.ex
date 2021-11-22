defmodule MathKidWeb.PageController do
  use MathKidWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
