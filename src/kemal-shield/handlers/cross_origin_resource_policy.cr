require "kemal"

# `Kemal::Shield::CrossOriginResourcePolicy` is a handler that sets the
# Cross-Origin-Resource-Policy HTTP header.
#
# Default value is "same-origin".
#
# The Cross-Origin-Resource-Policy header can be updated by changing
# the value of
# ```
# Kemal::Shield.config.corp
# ```
#
# Valid options
# ```
# "same-origin"
# "same-site"
# "cross-origin"
# ```
class Kemal::Shield::CrossOriginResourcePolicy < Kemal::Handler
  def call(context)
    if Kemal::Shield.config.corp_on
      context.response.headers["Cross-Origin-Resource-Policy"] = Kemal::Shield.config.corp
    end
    call_next(context)
  end
end
