defmodule ChatWeb.PageControllerTest do
  use ChatWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")

    # Assert
    assert html_response(conn, 200) =~ "Welcome to my Phoenix Live Chat Project"
  end
end
