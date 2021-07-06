require "kemal"

module Kemal
  module Shield
    # `Kemal::Shield::XFrameOptions` is a handler that sets the X-Frame-Options HTTP header.
    # This header restricts who can put your site in a frame which can help mitigate things
    # like clickjacking attacks.
    #
    # This handler sets the X-Frame-Options header to "SAMEORIGIN" by default.
    #
    # `Kemal::Shield::XFrameOptions` only supports "SAMEORIGIN" and "DENY".
    #
    # The X-Frame-Options header can be updated by changing the value of:
    # ```
    # Kemal::Shield.config.x_frame_options
    # ```
    #
    # This handler can be turned off by setting
    # ```
    # Kemal::Shield.config.x_frame_options_on = false
    # ```
    class XFrameOptions < Shield::Handler
      @option : String

      def initialize(opt = "SAMEORIGIN")
        @option = validated_option opt
      end

      def call(context)
        if Kemal::Shield.config.x_frame_options_on
          context.response.headers["X-Frame-Options"] = @option
        end
        call_next(context)
      end

      private def validated_option(value : String)
        frame_options = ["SAMEORIGIN", "SAME-ORIGIN", "DENY", "ALLOW-FROM"]
        normalized_value = value.upcase

        if !frame_options.includes?(normalized_value)
          raise ArgumentError.new("Invalid X-Frame-Options action: \"#{normalized_value}\"")
        end

        if normalized_value == "ALLOW-FROM"
          raise ArgumentError.new("X-Frame-Options no longer supports `ALLOW-FROM` due to poor browser support")
        end

        return normalized_value == "SAME-ORIGIN" ? "SAMEORIGIN" : normalized_value
      end
    end
  end
end
