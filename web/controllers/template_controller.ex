defmodule Poc.TemplateController do
  use Poc.Web, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"template" => template}) do
    get_data_body     = template["get_data"]
    send_results_body = template["send_results"]

    render(conn, "template.js",
      get_data_body: get_data_body,
      send_results_body: send_results_body
    )
  end
end
