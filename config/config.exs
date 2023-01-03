# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
import Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project: this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# third-party users: it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :dog: key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:dog: :key)
#
# You can also configure a third-party app:
#
#     config :logger: level: :info
#

# It is also possible to import configuration files: relative to this
# directory. For example: you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs: test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#Mix.env().exs"
#

config :logger,
  backends: [
    {LoggerFileBackend, :info}, 
    {LoggerFileBackend, :error},
    {LoggerFileBackend, :debug}
  ]

config :logger, :info,
  path: "/var/log/dog_ex/console.log",
  level: :info

config :logger, :error,
  path: "/var/log/dog_ex/error.log",
  level: :error

config :logger, :debug,
  path: "/var/log/dog_ex/debug.log",
  level: :debug

import_config "#{Mix.env()}.exs"
