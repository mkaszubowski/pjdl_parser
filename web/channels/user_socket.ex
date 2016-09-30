defmodule Poc.UserSocket do
  use Phoenix.Socket

  channel "uploads:lobby", Poc.UploadsChannel

  transport :websocket, Phoenix.Transports.WebSocket
  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
