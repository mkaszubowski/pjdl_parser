defmodule Poc.PageController do
  use Poc.Web, :controller

  alias Poc.UploadAgent

  def index(conn, _params) do
    render conn, "index.html"
  end

  def uploads(conn, _params) do
    uploads = UploadAgent.get_uploads()

    render(conn, "uploads.html", uploads: uploads)
  end
end
