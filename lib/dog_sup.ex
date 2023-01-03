# Generated by erl2ex (http://github.com/dazuma/erl2ex)
# From Erlang source: (Unknown source file)
# At: 2022-12-26 15:52:19


defmodule :dog_sup do

  @behaviour :supervisor
  require Logger


  defmacrop erlconst_SERVER() do
    quote do
      __MODULE__
    end
  end


  def start_link() do
    :supervisor.start_link({:local, erlconst_SERVER()}, __MODULE__, [])
  end


  def init(_args) do
    supFlags = %{strategy: :one_for_one, intensity: 10, period: 60}
    childSpecs = [%{id: :dog_turtle_sup, start: {:dog_turtle_sup, :start_link, []}, type: :supervisor}, %{id: :dog_agent, start: {:dog_agent, :start_link, []}, restart: :permanent, shutdown: 5000, type: :worker, modules: [:dog_agent]}]
    {:ok, {supFlags, childSpecs}}
  end

end
