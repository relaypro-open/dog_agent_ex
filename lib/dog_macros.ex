defmodule DogMacros do
  # Begin included file: dog.hrl

  defmacro erlconst_IPsExchange() do
    quote do
      "ips"
    end
  end


  defmacro erlconst_IptablesExchange() do
    quote do
      "iptables"
    end
  end


  defmacro erlconst_ConfigExchange() do
    quote do
      "config"
    end
  end


  defmacro erlconst_RUNDIR() do
    quote do
      '/etc/dog_ex'
    end
  end


  defmacro erlconst_CONFIG_FILE() do
    quote do
      '/etc/dog_ex/config.json'
    end
  end


  defmacro erlconst_LOCAL_CONFIG_FILE() do
    quote do
      '/etc/dog_ex/local_config.json'
    end
  end


  defmacro erlconst_SERVER() do
    quote do
      __MODULE__
    end
  end


  defmacro erlmacro_CMD(s) do
    quote do
      :dog_os.cmd(unquote(s))
    end
  end


  defmacro erlconst_PID_FILE() do
    quote do
      '/var/run/dog/dog.pid'
    end
  end


  defmacro erlconst_EC2_METADATA_BASE_URL() do
    quote do
      'http://169.254.169.254'
    end
  end


  # End included file: dog.hrl
end
