require "kemal"

# `Kemal::Shield::CrossOriginResourcePolicy` is a handler that sets the
# Cross-Origin-Resource-Policy HTTP header.
#
# Default value is "same-origin".
#
# The Cross-Origin-Resource-Policy header can be updated by changing
# the value of
# ```
# Kemal::Shield.config.cross_origin_resource_policy
# ```
#
# Valid options
# ```bash
# "same-origin"
# "same-site"
# "cross-origin"
# ```
class Kemal::Shield::CrossOriginResourcePolicy < Kemal::Handler
  def call(context)
    policy = Kemal::Shield.config.cross_origin_resource_policy
    context.response.headers["Cross-Origin-Resource-Policy"] = policy
    call_next(context)
  end
end
