# Since configuration is shared in umbrella projects, this file
# should only configure the :olivetree_api application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :olivetree_api, OlivetreeApi.Endpoint,
  http: [:inet6, port: System.get_env("PORT") || 4000, protocol_options: [max_keepalive: 5_000_000]],
  url: [host: "api.olivetree.app", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"

# config :olivetree_api, OlivetreeApi.Auth.Guardian,
#   issuer: "OlivetreeApi",
#   secret_key: "ft8TBDLTR8kFdU253xYhBxzX6aTyJK+dJKkGGUo8Ju8vPCgo5IEX590sh6OgY0s6"

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :olivetree, OlivetreeApi.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         :inet6,
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :olivetree, OlivetreeApi.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases (distillery)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :olivetree, OlivetreeApi.Endpoint, server: true
#
# Note you can't rely on `System.get_env/1` when using releases.
# See the releases documentation accordingly.

config :phoenix, :serve_endpoints, true

config :olivetree_api, OlivetreeApi.Endpoint,
  secret_key_base: "RmhHuux9myaRcly21QEL0uNCwHuv+3U66HU43mMbIpY4Ud5D3ka2A5RDgDzwREv1"
