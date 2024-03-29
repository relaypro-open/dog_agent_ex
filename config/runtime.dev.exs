import Config
import Dotenvy

source(["/etc/dog_ex/dot_env.config",".env", System.get_env()])

config :logger, :console, 
  metadata: [:module, :function, :line],
  level: :debug

config :dog,
  version: "local_docker",
  enforcing: true,
  use_ipsets: true,
  cmd_user: 'root' #must be a list
  
config :turtle,
  connection_config: [
    %{conn_name: :default, 
      username: env!("RABBITMQ_USERNAME", :charlist),
      password: env!("RABBITMQ_PASSWORD", :charlist),
      virtual_host: env!("RABBITMQ_VIRTUAL_HOST", :charlist),
      ssl_options: [
        cacertfile: env!("RABBITMQ_CACERTFILE", :charlist, '/etc/dog_ex/certs/ca.crt'), 
        certfile: env!("RABBITMQ_CERTFILE", :charlist, '/etc/dog_ex/certs/server.crt'), 
        keyfile: env!("RABBITMQ_KEYFILE", :charlist, '/etc/dog_ex/private/server.key'), 
        verify: :verify_peer, 
        server_name_indication: :disable, 
        fail_if_no_peer_cert: true], 
      deadline: 300000, 
      connections: [
        main: [{env!("RABBITMQ_HOST", :charlist), env!("RABBITMQ_PORT", :integer, 5673)}]]}
  ]

config :erldocker,
  docker_http: <<"http+unix://%2Fvar%2Frun%2Fdocker.sock">>

config :erlexec,
  debug: 0,
  verbose: false,
  root: true, #Allow running child processes as root
  args: [],
  #alarm: 5,  %% sec deadline for the port program to clean up child pids
  user: 'root',
  limit_users: ['root']

