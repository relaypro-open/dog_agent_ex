# Generated by erl2ex (http://github.com/dazuma/erl2ex)
# From Erlang source: (Unknown source file)
# At: 2022-12-26 15:52:17


defmodule :dog_ipset_test do
  require Logger

  def tester() do
    ip_tester()
  end


  def ip_tester() do
    :lists.foreach(fn _x ->
      :os.cmd('sudo ifup eth0:1')
      :timer.sleep(3000)
      :os.cmd('sudo ifdown eth0:1')
      :timer.sleep(3000)
    end, :lists.seq(1, 500))
  end


  def parallel_tester() do
    :erlang.spawn(write_tester())
    :erlang.spawn(read_tester())
  end


  def read_tester() do
    :lists.foreach(fn _x -> Logger.debug('~p~n', [:dog_ipset.read_hash()]) end, :lists.seq(1, 500))
  end


  def write_tester() do
    {:ok, ipset} = :file.read_file('/etc/dog_ex/ipset.txt')
    :lists.foreach(fn _x -> :dog_ipset.create_ipsets(ipset) end, :lists.seq(1, 500))
  end


  def serial_tester() do
    :lists.foreach(fn _x ->
      ipset = :dog_ipset.read_current_ipset()
      :ok = :dog_ipset.create_ipsets(ipset)
      Logger.debug('~p~n', [:dog_ipset.read_hash()])
    end, :lists.seq(1, 500))
  end


  def serial_cmd_tester() do
    :lists.foreach(fn _x ->
      Logger.debug('~s~n', [:os.cmd('cat /etc/dog_ex/ipset.txt | sudo /sbin/ipset restore -exist')])
      Logger.debug('~s~n', [:os.cmd('sudo /sbin/ipset save | md5sum')])
    end, :lists.seq(1, 500))
  end

end
