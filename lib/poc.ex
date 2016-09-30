defmodule Poc do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Poc.Endpoint, []),
      worker(Poc.UploadAgent, [])
    ]

    opts = [strategy: :one_for_one, name: Poc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Poc.Endpoint.config_change(changed, removed)
    :ok
  end
end
