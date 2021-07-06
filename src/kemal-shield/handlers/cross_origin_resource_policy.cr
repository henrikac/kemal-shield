require "kemal"

module Kemal
  module Shield
    # `Kemal::Shield::CrossOriginResourcePolicy` is a handler that sets the
    # Cross-Origin-Resource-Policy HTTP header.
    #
    # Default value is "same-origin".
    #
    # A custom Cross-Origin-Resource-Policy policy can be set by setting
    # ```
    # Kemal::Shield.config.corp
    # ```
    #
    # Valid policies
    # ```
    # "same-origin"
    # "same-site"
    # "cross-origin"
    # ```
    class CrossOriginResourcePolicy < Shield::Handler
      @policy : String

      def initialize(@policy = "same-origin")
        if !valid_policy?(@policy)
          raise ArgumentError.new("Cross-Origin-Resource-Policy does not support the #{@policy} policy")
        end
      end

      def call(context)
        if Kemal::Shield.config.corp_on
          context.response.headers["Cross-Origin-Resource-Policy"] = @policy
        end
        call_next(context)
      end

      private def valid_policy?(policy : String)
        allowed_policies = [
          "same-origin",
          "same-site",
          "cross-origin"
        ]

        return false if !allowed_policies.includes?(policy)

        return true
      end
    end
  end
end
