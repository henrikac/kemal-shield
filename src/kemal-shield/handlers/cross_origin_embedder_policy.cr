require "kemal"

module Kemal
  module Shield
    # `Kemal::Shield::CrossOriginEmbedderPolicy` is a handler that sets the
    # Cross-Origin-Embedder-Policy HTTP header.
    #
    # This handler can be turned off by setting
    # ```
    # Kemal::Shield.config.coep_on = false
    # ```
    class CrossOriginEmbedderPolicy < Shield::Handler
      def call(context)
        if Kemal::Shield.config.coep_on
          context.response.headers["Cross-Origin-Embedder-Policy"] = "require-corp"
        end
        call_next(context)
      end
    end
  end
end
