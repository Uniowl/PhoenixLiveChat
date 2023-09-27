defmodule ChatWeb.ChatRoomLive do
   use ChatWeb, :live_view
  def mount(%{"id" => room_id}, _session, socket) do
    username = MnemonicSlugs.generate_slug(2)
    if connected?(socket) do
      ChatWeb.Endpoint.subscribe(room_id)
      ChatWeb.Presence.track(self(), room_id, username, %{})
    end
    {:ok, assign(
      socket,
      room_id: room_id,
      username: username,
      messages: [],
      users: [],
      temporary_assigns: [messages: []])}
  end

  def handle_info(%{event: "message", payload: message}, socket) do
    {:noreply, assign(socket, :messages, [message])}
  end

  def handle_info(%{event: "presence_diff", payload: %{leaves: leaves, joins: joins}}, socket) do
    join_messages =
      Map.keys(joins)
      |> Enum.map(&(%{id: UUID.uuid4(), username: "Server", text: "#{&1} has joined the chat. Welcome!"}))
    leave_messages =
      Map.keys(leaves)
      |> Enum.map(&(%{id: UUID.uuid4(), username: "Server", text: "#{&1} has left the chat"}))
    users =
      ChatWeb.Presence.list(socket.assigns.room_id)
      |> Map.keys()
    {:noreply, assign(socket, messages: join_messages ++ leave_messages, users: users)}
  end

  def handle_event("send", %{"text" => text}, socket) do
    ChatWeb.Endpoint.broadcast(socket.assigns.room_id, "message", %{text: text, username: socket.assigns.username, id: UUID.uuid4()})
    {:noreply, socket}
  end


  def display_message(assigns = %{username: "Server"}) do
    ~H"""
      <p id={@id} style="margin: 2px; text-align: center;"><em><%= @text %></em></p>
    """
  end

  def display_message(assigns) do
    ~H"""
      <p id={@id} style="margin: 2px;"><b><%= @username %></b>: <%= @text %></p>
    """
  end
end
