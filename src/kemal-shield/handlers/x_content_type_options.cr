require "kemal"

module Kemal
  module Shield
    # `Kemal::Shield::XContentTypeOptions` is a handler that sets the
    # X-Content-Type-Options HTTP header.
    #
    # This handler can be turned off by setting
    # ```
    # Kemal::Shield.config.no_sniff = false
    # ```
    class XContentTypeOptions < Shield::Handler
      def call(context)
        if Kemal::Shield.config.no_sniff
          context.response.headers["X-Content-Type-Options"] = "nosniff"
        end
        call_next(context)
      end
    end
  end
end
