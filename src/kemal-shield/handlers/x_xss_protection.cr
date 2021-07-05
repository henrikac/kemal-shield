require "kemal"

module Kemal
  module Shield
    # `Kemal::Shield::XXSSProtection` disables the X-XSS-Protection HTTP header
    # by setting it to "0".
    #
    # The X-XSS-Protection HTTP header caused some unintended security issues
    # and many browsers has therefore chosen to remove it. (see [this](https://github.com/helmetjs/helmet/issues/230) for more information)
    #
    # This handler can be turned off by setting
    # ```
    # Kemal::Shield.config.x_xss_protection = true
    # ```
    class XXSSProtection < Kemal::Handler
      def call(context)
        if !Kemal::Shield.config.x_xss_protection
          context.response.headers["X-XSS-Protection"] = "0"
        end
        call_next(context)
      end
    end
  end
end
