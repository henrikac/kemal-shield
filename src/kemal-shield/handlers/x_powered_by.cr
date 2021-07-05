require "kemal"

module Kemal
  module Shield
    # `Kemal::Shield::XPoweredBy` removes the X-Powered-By HTTP header.
    #
    # This handler can be turned off by setting
    # ```
    # Kemal::Shield.config.hide_powered_by = false
    # ```
    class XPoweredBy < Kemal::Handler
      def call(context)
        if Kemal::Shield.config.hide_powered_by
          context.response.headers.delete("X-Powered-By")
        end
        call_next(context)
      end
    end
  end
end
