import Config

config :fex, fixer: FEx.APIs.Fixer.HTTPClient

import_config "#{config_env()}.exs"
