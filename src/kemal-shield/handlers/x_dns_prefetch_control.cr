require "kemal"

# `Kemal::Shield::XDNSPrefetchControl` is a handler that sets the
# X-DNS-Prefetch-Control HTTP header to either "on" or "off".
#
# X-DNS-Prefetch-Control helps controlling browsers' DNS prefetching.
#
# The default value if "off".
#
# The X-DNS-Prefetch-Control header can be updated to "on" by setting
# ```
# Kemal::Shield.config.x_dns_prefetch_control = true
# ```
class Kemal::Shield::XDNSPrefetchControl < Kemal::Handler
  def call(context)
    value = Kemal::Shield.config.x_dns_prefetch_control ? "on" : "off"
    context.response.headers["X-DNS-Prefetch-Control"] = value
    call_next(context)
  end
end
