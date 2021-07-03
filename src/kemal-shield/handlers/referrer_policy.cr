require "kemal"

# `Kemal::Shield::ReferrerPolicy` is a handler that sets the Referrer-Policy HTTP header.
#
# The default value is "no-referrer".
#
# The Referrer-Policy header can by updated by changing the value of:
# ```
# Kemal::Shield.config.referrer_policy
# ```
#
# Valid options:
# ```bash
# "no-referrer"
# "no-referrer-when-downgrade"
# "same-origin"
# "origin"
# "strict-origin"
# "origin-when-cross-origin"
# "strict-origin-when-cross-origin"
# "unsafe-url"
# ```
class Kemal::Shield::ReferrerPolicy < Kemal::Handler
  def call(context)
    context.response.headers["Referrer-Policy"] = Kemal::Shield.config.referrer_policy
    call_next(context)
  end
end
