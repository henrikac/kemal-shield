require "kemal"

module Kemal
  module Shield
    # `Kemal::Shield::CrossOriginOpenerPolicy` is a handler that sets the
    # Cross-Origin-Opener-Policy HTTP header.
    #
    # Default value is "same-origin".
    #
    # A custom Cross-Origin-Opener-Policy policy can be set by setting
    # ```
    # Kemal::Shield.config.coop
    # ```
    #
    # Valid policies
    # ```
    # "same-origin"
    # "same-origin-allow-popups"
    # "unsafe-none"
    # ```
    class CrossOriginOpenerPolicy < Shield::Handler
      # The Cross-Origin-Opener-Policy policy
      @policy : String

      def initialize(@policy = "same-origin")
        if !valid_policy?(@policy)
          raise ArgumentError.new("Cross-Origin-Opener-Policy does not support the #{@policy} policy")
        end
      end

      def call(context)
        if Kemal::Shield.config.coop_on
          context.response.headers["Cross-Origin-Opener-Policy"] = @policy
        end
        call_next(context)
      end

      private def valid_policy?(policy : String)
        allowed_policies = [
          "same-origin",
          "same-origin-allow-popups",
          "unsafe-none"
        ]

        return false if !allowed_policies.includes?(policy)

        return true
      end
    end
  end
end
