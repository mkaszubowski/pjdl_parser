defmodule Poc.UploadController do
  use Poc.Web, :controller

  alias Poc.JobTemplateAgent

  def index(conn, _params) do
    templates = JobTemplateAgent.get_templates()

    render(conn, "index.html", templates: templates)
  end

  def show(conn, %{"id" => id}) do
    template = JobTemplateAgent.get_template(id)
    json(conn, template)
  end

  def delete(conn, %{"id" => id}) do
    JobTemplateAgent.delete_template(id)
    redirect(conn, to: upload_path(conn, :index))
  end

  def edit(conn, %{"id" => id}) do
    template = JobTemplateAgent.get_template(id)
    render(conn, "edit.html", template: template)
  end

  def update(conn, %{"id" => id, "template" => template_params}) do
    JobTemplateAgent.update_template(id, template_params)
    redirect(conn, to: upload_path(conn, :index))
  end
end
