defmodule ChatWeb.ChatRoomLiveTest do
  use ChatWeb.ConnCase

  @test_room "test-room"

  test "Connects to chat room", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/#{@test_room}")

    assert html =~ "<h1>You are chatting in the room: <strong> #{@test_room} </strong>"
  end

  test "User appears in userlist", %{conn: conn} do
    {:ok, view, html} = live(conn, "/#{@test_room}")

    IO.inspect(view)
    IO.inspect(html)
    assert html =~ conn.assigns.username
  end
end
