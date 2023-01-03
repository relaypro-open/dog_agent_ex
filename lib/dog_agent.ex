# Generated by erl2ex (http://github.com/dazuma/erl2ex)
# From Erlang source: (Unknown source file)
# At: 2022-12-26 15:52:13


defmodule :dog_agent do

  @behaviour :gen_server
  require Logger

  @spec start_link() :: {:ok, pid()} | :ignore | {:error, {:already_started, pid()} | term()}


  def start_link() do
    :gen_server.start_link({:local, __MODULE__}, __MODULE__, [], [])
  end


  @spec watch_iptables() :: :ok


  def watch_iptables() do
    :gen_server.call(__MODULE__, :watch_iptables)
  end


  @spec watch_interfaces() :: :ok


  def watch_interfaces() do
    :gen_server.call(__MODULE__, :watch_interfaces)
  end


  @spec keepalive() :: :ok


  def keepalive() do
    :gen_server.call(__MODULE__, :keepalive)
  end


  @spec read_hash() :: list()


  def read_hash() do
    try do
      :gen_server.call(__MODULE__, :read_hash, 20000)
    catch
      class, reason ->
        Logger.debug('Class, Reason: #{class}, #{reason}')
        {class, reason}
    end
  end


  @spec create_ipsets(iolist()) :: :ok


  def create_ipsets(ipsets) do
    try do
      :gen_server.call(__MODULE__, {:create_ipsets, ipsets}, 20000)
    catch
      class, reason ->
        Logger.debug('Class, Reason: #{class}, #{reason}')
        {class, reason}
    end
  end


  @spec set_state(:dog_state.dog_state()) :: {:ok, :dog_state.dog_state()}


  def set_state(state) do
    :gen_server.call(__MODULE__, {:set_state, state})
  end


  @spec get_group() :: {:ok, binary()}


  def get_group() do
    :gen_server.call(__MODULE__, {:get_group})
  end


  @spec set_group(binary()) :: {:ok, :dog_state.dog_state()}


  def set_group(group) do
    :gen_server.call(__MODULE__, {:set_group, group})
  end


  @spec get_hostname() :: {:ok, binary()}


  def get_hostname() do
    :gen_server.call(__MODULE__, {:get_hostname})
  end


  @spec set_hostname(binary()) :: {:ok, :dog_state.dog_state()}


  def set_hostname(hostname) do
    :gen_server.call(__MODULE__, {:set_hostname, hostname})
  end


  @spec get_interfaces() :: {:ok, binary()}


  def get_interfaces() do
    :gen_server.call(__MODULE__, {:get_interfaces})
  end


  @spec set_interfaces(binary()) :: {:ok, :dog_state.dog_state()}


  def set_interfaces(interfaces) do
    :gen_server.call(__MODULE__, {:set_interfaces, interfaces})
  end


  @spec get_location() :: {:ok, binary()}


  def get_location() do
    :gen_server.call(__MODULE__, {:get_location})
  end


  @spec set_location(binary()) :: {:ok, :dog_state.dog_state()}


  def set_location(location) do
    :gen_server.call(__MODULE__, {:set_location, location})
  end


  @spec get_environment() :: {:ok, binary()}


  def get_environment() do
    :gen_server.call(__MODULE__, {:get_environment})
  end


  @spec set_environment(binary()) :: {:ok, :dog_state.dog_state()}


  def set_environment(environment) do
    :gen_server.call(__MODULE__, {:set_environment, environment})
  end


  @spec get_hostkey() :: {:ok, binary()}


  def get_hostkey() do
    :gen_server.call(__MODULE__, {:get_hostkey})
  end


  @spec set_hostkey(binary()) :: {:ok, :dog_state.dog_state()}


  def set_hostkey(hostkey) do
    :gen_server.call(__MODULE__, {:set_hostkey, hostkey})
  end


  @spec get_state() :: {:ok, :dog_state.dog_state()}


  def get_state() do
    :gen_server.call(__MODULE__, :get_state)
  end


  @spec get_host_routing_key() :: {:ok, :dog_state.dog_state()}


  def get_host_routing_key() do
    :gen_server.call(__MODULE__, :host_routing_key)
  end


  @spec host_routing_key() :: char_list()


  def host_routing_key() do
    routingKey = get_host_routing_key()
    :erlang.binary_to_list(routingKey)
  end


  @spec get_group_routing_key() :: {:ok, :dog_state.dog_state()}


  def get_group_routing_key() do
    :gen_server.call(__MODULE__, :group_routing_key)
  end


  @spec group_routing_key() :: char_list()


  def group_routing_key() do
    routingKey = get_group_routing_key()
    :erlang.binary_to_list(routingKey)
  end


  @spec watch_config() :: :ok


  def watch_config() do
    :gen_server.call(__MODULE__, :watch_config)
  end


  @spec init(term()) :: no_return()


  def init(_args) do
    waitSeconds = 15
    waitMilliSeconds = waitSeconds * 1000
    :timer.sleep(waitMilliSeconds)
    watchInterfacesPollMilliseconds = :application.get_env(:dog, :watch_interfaces_poll_seconds, 5) * 1000
    _ipsTimer = :erlang.send_after(watchInterfacesPollMilliseconds, self(), :watch_interfaces)
    keepalivePollMilliseconds = :application.get_env(:dog, :keepalive_initial_delay_seconds, 60) * 1000
    _keepaliveTimer = :erlang.send_after(keepalivePollMilliseconds, self(), :keepalive)
    state = init_state()
    stateMap = :dog_state.to_map(state)
    :dog_interfaces.publish_to_queue(stateMap)
    {:ok, state}
  end


  defp init_state() do
    :ok = :dog_config.do_init_config()
    provider = :dog_interfaces.get_provider()
    {:ok, interfaces} = :dog_interfaces.get_interfaces(provider, [])
    {ec2Region, ec2InstanceId, ec2AvailabilityZone, ec2SecurityGroupIds, ec2OwnerId, ec2InstanceTags, ec2VpcId, ec2SubnetId} = :dog_interfaces.ec2_info()
    {oS_Distribution, oS_Version} = :dog_interfaces.os_info()
    {:ok, hostname} = :dog_interfaces.get_fqdn()
    hash4Ipsets = :dog_iptables.create_hash(:dog_iptables.read_current_ipv4_ipsets())
    hash6Ipsets = :dog_iptables.create_hash(:dog_iptables.read_current_ipv6_ipsets())
    hash4Iptables = :dog_iptables.create_hash(:dog_iptables.read_current_ipv4_iptables())
    hash6Iptables = :dog_iptables.create_hash(:dog_iptables.read_current_ipv6_iptables())
    ipsetHash = :dog_ipset.read_hash()
    {:ok, version} = :dog.get_version()
    updateType = :force
    {group, location, environment, hostkey} = case(:dog_config.read_config_file()) do
      {:ok, configMap} ->
        {:maps.get("group", configMap), :maps.get("location", configMap), :maps.get("environment", configMap), :maps.get("hostkey", configMap)}
      :file_read_error ->
        {"", "*", "*", ""}
    end
    hostkey1 = case(hostkey) do
      <<>> ->
        throw('hostkey_not_set')
      _ ->
        hostkey
    end
    state = :dog_state.dog_state(group, hostname, location, environment, hostkey1, interfaces, version, hash4Ipsets, hash6Ipsets, hash4Iptables, hash6Iptables, provider, updateType, ipsetHash, ec2Region, ec2InstanceId, ec2AvailabilityZone, ec2SecurityGroupIds, ec2OwnerId, ec2InstanceTags, oS_Distribution, oS_Version, ec2VpcId, ec2SubnetId)
    state
  end


  @spec handle_call(term(), {pid(), term()}, :dog_state.dog_state()) :: {:reply, :ok, any()}


  def handle_call({:create_ipsets, ipsets}, _from, state) do
    :dog_ipset.create_ipsets(ipsets)
    {:reply, :ok, state}
  end

  def handle_call(:read_hash, _from, state) do
    hash = :dog_ipset.read_hash()
    {:reply, hash, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:set_state, state}, _from, _oldState) do
    {:reply, :ok, state}
  end

  def handle_call({:get_group}, _from, state) do
    hostkey = :dog_state.get_group(state)
    {:reply, hostkey, state}
  end

  def handle_call({:set_group, group}, _from, stateOld) do
    stateNew = :dog_state.set_group(stateOld, group)
    {:reply, :ok, stateNew}
  end

  def handle_call({:get_hostname}, _from, state) do
    hostkey = :dog_state.get_hostname(state)
    {:reply, hostkey, state}
  end

  def handle_call({:set_hostname, hostname}, _from, stateOld) do
    stateNew = :dog_state.set_hostname(stateOld, hostname)
    {:reply, :ok, stateNew}
  end

  def handle_call({:get_location}, _from, state) do
    hostkey = :dog_state.get_location(state)
    {:reply, hostkey, state}
  end

  def handle_call({:set_location, location}, _from, stateOld) do
    stateNew = :dog_state.set_location(stateOld, location)
    {:reply, :ok, stateNew}
  end

  def handle_call({:get_environment}, _from, state) do
    hostkey = :dog_state.get_environment(state)
    {:reply, hostkey, state}
  end

  def handle_call({:set_environment, environment}, _from, stateOld) do
    stateNew = :dog_state.set_environment(stateOld, environment)
    {:reply, :ok, stateNew}
  end

  def handle_call({:get_hostkey}, _from, state) do
    hostkey = :dog_state.get_hostkey(state)
    {:reply, hostkey, state}
  end

  def handle_call({:set_hostkey, hostkey}, _from, stateOld) do
    stateNew = :dog_state.set_hostkey(stateOld, hostkey)
    {:reply, :ok, stateNew}
  end

  def handle_call({:get_interfaces}, _from, state) do
    hostkey = :dog_state.get_interfaces(state)
    {:reply, hostkey, state}
  end

  def handle_call({:set_interfaces, interfaces}, _from, stateOld) do
    stateNew = :dog_state.set_interfaces(stateOld, interfaces)
    {:reply, :ok, stateNew}
  end

  def handle_call(:host_routing_key, _from, state) do
    {:ok, routingKey} = :dog_ips.do_get_host_routing_key(state)
    {:reply, routingKey, state}
  end

  def handle_call(:group_routing_key, _from, state) do
    {:ok, routingKey} = :dog_ips.do_get_group_routing_key(state)
    {:reply, routingKey, state}
  end

  def handle_call(:watch_config, _from, state) do
    :dog_config.do_watch_config()
    {:reply, state}
  end

  def handle_call(_request, _from, state) do
    {:reply, :ok, state}
  end


  @spec handle_cast(_, _) :: {:noreply, _} | {:stop, :normal, _} when _: any()


  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  def handle_cast(msg, state) do
    {:noreply, state}
  end


  @spec handle_info(term(), :dog_state.dog_state()) :: {:stop, :normal, :dog_state.dog_state()} | {:noreply, :dog_state.dog_state()}


  def handle_info(:sub, state) do
    {:noreply, state}
  end

  def handle_info(:watch_interfaces, state) do
    {:ok, newState} = :dog_ips.do_watch_interfaces(state)
    watchInterfacesPollMilliseconds = :application.get_env(:dog, :watch_interfaces_poll_seconds, 5) * 1000
    :erlang.send_after(watchInterfacesPollMilliseconds, self(), :watch_interfaces)
    {:noreply, newState}
  end

  def handle_info(:keepalive, state) do
    {:ok, newState} = :dog_ips.do_keepalive(state)
    keepalivePollSeconds = :application.get_env(:dog, :keepalive_poll_seconds, 60) * 1000
    :erlang.send_after(keepalivePollSeconds, self(), :keepalive)
    {:noreply, newState}
  end

  def handle_info(info, state) do
    {:noreply, state}
  end


  @spec terminate(_, :dog_state.dog_state()) :: {:close} when _: any()


  def terminate(reason, state) do
    {:close}
  end


  @spec code_change(_, :dog_state.dog_state(), _) :: {:ok, :dog_state.dog_state()} when _: any()


  def code_change(_oldVsn, state, _extra) do
    {:ok, state}
  end

end
