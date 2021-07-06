require "kemal"

module Kemal
  module Shield
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
    #
    # This handler can be turned of by setting
    # ```
    # Kemal::Shield.config.x_dns_control_on = false
    # ```
    class XDNSPrefetchControl < Shield::Handler
      def call(context)
        if Kemal::Shield.config.x_dns_prefetch_control_on
          value = Kemal::Shield.config.x_dns_prefetch_control ? "on" : "off"
          context.response.headers["X-DNS-Prefetch-Control"] = value
        end
        call_next(context)
      end
    end
  end
end
