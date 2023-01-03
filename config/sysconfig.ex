# Generated by erl2ex (http://github.com/dazuma/erl2ex)
# From Erlang source: (Unknown source file)
# At: 2023-01-02 10:04:26


defmodule :sysconfig do

  def x() do
    [dog: 
      [
        version: 'local_docker', 
        enforcing: true, 
        use_ipsets: true
      ], 
      kernel: 
      [
        inet_dist_use_interface: {127, 0, 0, 1}, 
        logger_level: :all, 
        logger: [
          {:handler, :default, 
            :logger_std_h, %{
              level: :error, 
              formatter: {
                :flatlog, 
                %{max_depth: 3, term_depth: 50, colored: true}}}}, 
          {:handler, :disk_log_debug, 
            :logger_disk_log_h, %{
              config: %{
                file: '/var/log/dog/debug.log', 
                type: :wrap, 
                max_no_files: 5, 
                max_no_bytes: 10000000}, 
              level: :debug, 
              formatter: {:flatlog, %{map_depth: 3, term_depth: 50}}}}, 
          {:handler, :disk_log_error, 
            :logger_disk_log_h, %{
              config: %{
                file: '/var/log/dog/error.log', 
                type: :wrap, max_no_files: 5, max_no_bytes: 10000000}, 
              level: :error, 
              formatter: {:flatlog, %{map_depth: 3, term_depth: 50}}}}]
      ], 
      turtle: [
        connection_config: [
          %{conn_name: :default, 
            username: 'guest', 
            password: 'guest', 
            virtual_host: 'dog', 
            ssl_options: [
              cacertfile: '/etc/dog/certs/ca.crt', 
              certfile: '/etc/dog/certs/server.crt', 
              keyfile: '/etc/dog/private/server.key', 
              verify: :verify_peer, 
              server_name_indication: :disable, 
              fail_if_no_peer_cert: true], 
            deadline: 300000, 
            connections: [
              main: [{'rabbitmq', 5673}]]}]
      ], 
      erldocker: [docker_http: "http+unix://%2Fvar%2Frun%2Fdocker.sock"], 
      erlexec: [debug: 0, verbose: false, root: true, args: [], user: 'root', limit_users: ['root']]]
  end

end