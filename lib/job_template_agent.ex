defmodule Poc.JobTemplateAgent do
  @name :job_template_agent

  def start_link() do
    Agent.start_link(fn -> [] end, name: @name)
  end

  def add_template(job_template) do
    case get_template(job_template.id) do
      nil ->
        Agent.update(@name, fn job_templates -> [job_template | job_templates] end)
        {:ok, job_template}
      _template ->
        {:error, :alread_uploaded}
    end
  end

  def delete_template(%JobTemplate{id: job_id}) do
    delete_template(job_id)
  end
  def delete_template(id) do
    Agent.update(@name, fn job_templates ->
      Enum.filter(job_templates, fn (template) -> template.id != id end)
    end)
  end

  def update_template(id, template_params) do
    template = get_template(id)
    templates = get_templates |> Enum.filter(fn t -> t.id != id end)

    updated_template = Map.merge(template, parsed_params(template_params))
    IO.inspect updated_template
    Agent.update(@name, fn job_templates -> [updated_template | templates] end)
  end

  defp parsed_params(params) do
    %{
      short_description:  params["short_description"],
      results_visibility: params["results_visibility"],
      instantiation:      params["instantiation"]
    }
  end

  def get_templates() do
    Agent.get(@name, &(&1))
  end

  def get_template(template_id) do
    get_templates() |> Enum.find(fn t -> t.id == template_id end)
  end
end
