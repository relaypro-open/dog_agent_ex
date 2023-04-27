import Config
import Dotenvy

source(["/etc/dog_ex/dot_env.config",".env", System.get_env()])

config :dog,
  version: "NOT_SET",
  enforcing: true,
  use_ipsets: true,
  cmd_user: 'dog' #must be a charlist
  
config :turtle,
  connection_config: [
    %{conn_name: :default, 
      username: env!("RABBITMQ_USERNAME", :charlist),
      password: env!("RABBITMQ_PASSWORD", :charlist),
      virtual_host: env!("RABBITMQ_VIRTUAL_HOST", :charlist),
      ssl_options: [
        cacertfile: env!("RABBITMQ_CACERTFILE", :charlist, '/var/consul/data/pki/certs/ca.crt'), 
        certfile: env!("RABBITMQ_CERTFILE", :charlist, '/var/consul/data/pki/certs/server.crt'), 
        keyfile: env!("RABBITMQ_KEYFILE", :charlist, '/var/consul/data/pki/private/server.key'), 
        verify: :verify_peer, 
        server_name_indication: :disable, 
        fail_if_no_peer_cert: true], 
      deadline: 300000, 
      connections: [
        main: [{env!("RABBITMQ_HOST", :charlist), env!("RABBITMQ_PORT", :integer, 5673)}]]}
  ]

config :erldocker,
  docker_http: "http+unix://var/run/docker.sock"

config :erlexec,
  debug: 0,
  verbose: false,
  root: true, #Allow running child processes as root
  args: [],
  #alarm: 5,  %% sec deadline for the port program to clean up child pids
  user: 'dog',
  limit_users: ['root','dog']

