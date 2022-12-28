import Config

config :dog_agent_ex,
  version: "local_docker",
  enforcing: true,
  use_ipsets: true

config :remix,
  escript: true,
  silent: true

config :turtle,
  connection_config: [
    conn_name: :default,

    username: "guest",
    password: "guest",
    virtual_host: "dog",
    ssl_options: [
      cacertfile: '/etc/dog_ex/certs/ca.crt',
      certfile:   '/etc/dog_ex/certs/server.crt',
      keyfile:    '/etc/dog_ex/private/server.key',
      verify: :verify_peer,
      server_name_indication: :disable,
      fail_if_no_peer_cert: true
    ],
    deadline: 300000,
    connections: [
        main: [
          {"rabbitmq", 5673 } 
        ]
    ]
  ]
  
config :erldocker,
  docker_http: <<"http+unix://%2Fvar%2Frun%2Fdocker.sock">>

#config :erlexec,
#  debug: 1,
#  verbose: true,
#  root: true, #Allow running child processes as root
#  args: [],
#  #alarm: 5,  %% sec deadline for the port program to clean up child pids
#  user: "root",
#  limit_users: ["root"]

#config :thumper,
#  substitution_rules: [
#    cluster: {:edb, :get_cluster_id, []}
#  ],
#  thumper_svrs: [:default, :publish],
#  brokers: [
#    default: [
#      rabbitmq_config: [
#        host: 'dog-ubuntu-server.lxd',
#        port: 5673,
#        api_port: 15672,
#        virtual_host: "dog",
#        user: "dog_trainer",
#        password: "327faf06-c3f5-11e7-9765-7831c1be5b34",
#        ssl_options: [
#          cacertfile: '/var/consul/data/pki/certs/ca.crt',
#          certfile: '/var/consul/data/pki/certs/server.crt',
#          keyfile: '/var/consul/data/pki/private/server.key',
#          verify: :verify_peer,
#          server_name_indication: :disable,
#          fail_if_no_peer_cert: true
#        ],
#        broker_config: {:thumper_tx, "/opt/dog_trainer_ex/priv/broker.tx" }
#      ]
#    ],
#    publish: [rabbitmq_config: :default]
#  ],
#  queuejournal: [
#    enabled: true,
#    dir: '/opt/dog_trainer_ex/queuejournal',
#    memqueue_max: 10000,
#    check_journal: true
#  ]
