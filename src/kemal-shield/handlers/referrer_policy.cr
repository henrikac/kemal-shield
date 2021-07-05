require "kemal"

module Kemal
  module Shield
    # `Kemal::Shield::ReferrerPolicy` is a handler that sets the Referrer-Policy HTTP header.
    #
    # The default value is "no-referrer".
    #
    # A custom Referrer-Policy policy can be set by setting
    # ```
    # Kemal::Shield.config.referrer_policy
    # ```
    #
    # Example
    # ```
    # Kemal::Shield.config.referrer_policy = ["same-origin", "origin", "strict-origin"]
    # ```
    #
    # This will set the Referrer-Policy policy to "same-origin,origin,strict-origin".
    #
    # Valid policies:
    # ```
    # "no-referrer"
    # "no-referrer-when-downgrade"
    # "same-origin"
    # "origin"
    # "strict-origin"
    # "origin-when-cross-origin"
    # "strict-origin-when-cross-origin"
    # "unsafe-url"
    # ```
    class ReferrerPolicy < Kemal::Handler
      @policy : String

      def initialize(policy_tokens : Array(String) = ["no-referrer"])
        @policy = serialized_policy(policy_tokens)
      end

      def call(context)
        if Kemal::Shield.config.referrer_on
          context.response.headers["Referrer-Policy"] = @policy
        end
        call_next(context)
      end

      private def serialized_policy(tokens : Array(String))
        allowed_tokens = [
          "no-referrer",
          "no-referrer-when-downgrade",
          "same-origin",
          "origin",
          "strict-origin",
          "origin-when-cross-origin",
          "strict-origin-when-cross-origin",
          "unsafe-url",
          ""
        ]

        if tokens.empty?
          raise ArgumentError.new("Referrer-Policy received no policy tokens")
        end

        seen = Set(String).new
        tokens.each do |token|
          if !allowed_tokens.includes?(token)
            raise ArgumentError.new("Referrer-Policy received an unexpected policy token #{token}")
          elsif seen.includes?(token)
            raise ArgumentError.new("Referrer-Policy received a duplicate policy token #{token}")
          end
          seen << token
        end

        return tokens.join(",")
      end
    end
  end
end
