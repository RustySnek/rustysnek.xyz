defmodule Rustysnek.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RustysnekWeb.Telemetry,
      {Venomous.SnakeSupervisor, [strategy: :one_for_one, max_restarts: 0, max_children: 250]},
      {DNSCluster, query: Application.get_env(:rustysnek, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Rustysnek.PubSub},
      # Start a worker by calling: Rustysnek.Worker.start_link(arg)
      # {Rustysnek.Worker, arg},
      # Start to serve requests, typically the last entry
      RustysnekWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rustysnek.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RustysnekWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
