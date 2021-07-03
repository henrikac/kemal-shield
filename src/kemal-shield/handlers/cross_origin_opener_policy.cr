require "kemal"

# `Kemal::Shield::CrossOriginOpenerPolicy` is a handler that sets the
# Cross-Origin-Opener-Policy HTTP header.
#
# Default value is "same-origin".
#
# The Cross-Origin-Opener-Policy header can be updated by changing
# the value of
# ```
# Kemal::Shield.config.coop
# ```
#
# Valid options
# ```
# "same-origin"
# "same-origin-allow-popups"
# "unsafe-none"
# ```
class Kemal::Shield::CrossOriginOpenerPolicy < Kemal::Handler
  def call(context)
    if Kemal::Shield.config.coop_on
      context.response.headers["Cross-Origin-Opener-Policy"] = Kemal::Shield.config.coop
    end
    call_next(context)
  end
end
