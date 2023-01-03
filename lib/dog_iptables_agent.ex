# Generated by erl2ex (http://github.com/dazuma/erl2ex)
# From Erlang source: (Unknown source file)
# At: 2022-12-26 15:52:17


defmodule :dog_iptables_agent do

  @behaviour :gen_server
  require Logger


  defmacrop erlconst_SERVER() do
    quote do
      __MODULE__
    end
  end


  def init(_args) do
    state = %{}
    {:ok, state}
  end


  @spec start_link() :: {:ok, pid()} | :ignore | {:error, {:already_started, pid()} | term()}


  def start_link() do
    :gen_server.start_link({:local, erlconst_SERVER()}, __MODULE__, [], [])
  end


  @spec handle_call(term(), {pid(), term()}, %{}) :: {:reply, :ok, any()}


  def handle_call(_request, _from, state) do
    {:reply, :ok, state}
  end


  @spec handle_cast(_, _) :: {:noreply, _} | {:stop, :normal, _} when _: any()


  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  def handle_cast(msg, state) do
    Logger.debug('unknown_message: Msg: #{msg}, State: #{state}')
    {:noreply, state}
  end


  def handle_info(info, state) do
    Logger.debug('unknown_message: Info: #{info}, State: #{state}')
    {:noreply, state}
  end


  @spec terminate(_, %{}) :: {:close} when _: any()


  def terminate(reason, state) do
    Logger.debug('terminate: Reason: #{reason}, State: #{state}')
    {:close}
  end


  @spec code_change(_, %{}, _) :: {:ok, %{}} when _: any()


  def code_change(_oldVsn, state, _extra) do
    {:ok, state}
  end

end
