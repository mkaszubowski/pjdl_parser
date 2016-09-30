defmodule Poc.UploadsChannel do
  use Poc.Web, :channel

  def join("uploads:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  defp authorized?(_payload) do
    true
  end
end
