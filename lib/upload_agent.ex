defmodule Poc.UploadAgent do
  @name :upload_agent

  def start_link() do
    Agent.start_link(fn -> [] end, name: @name)
  end

  def add_upload(filename) do
    Agent.update(@name, fn uploads -> [filename | uploads] end)
  end

  def get_uploads() do
    Agent.get(@name, &(&1))
  end
end
