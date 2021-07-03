require "kemal"

# `Kemal::Shield::CrossOriginOpenerPolicy` is a handler that sets the
# Cross-Origin-Opener-Policy HTTP header.
#
# Default value is "same-origin".
#
# The Cross-Origin-Opener-Policy header can be updated by changing
# the value of
# ```
# Kemal::Shield.config.cross_origin_opener_policy
# ```
#
# Valid options
# ```bash
# "same-origin"
# "same-origin-allow-popups"
# "unsafe-none"
# ```
class Kemal::Shield::CrossOriginOpenerPolicy < Kemal::Handler
  def call(context)
    policy = Kemal::Shield.config.cross_origin_opener_policy
    context.response.headers["Cross-Origin-Opener-Policy"] = policy
    call_next(context)
  end
end
