require "kemal"

module Kemal
  module Shield
    # `Kemal::Shield::ContentSecurityPolicy` sets the Content-Security-Policy (CSP) header.
    # This header can help mitigate different kinds of client side attacks, e.g. cross-site-scripting (XSS).
    #
    # The following directives are set unless custom directives are supplied:
    # ```
    # default-src 'self';
    # base-uri 'self';
    # block-all-mixed-content;
    # font-src 'self' https: data:;
    # frame-ancestors 'self';
    # img-src 'self' data:;
    # object-src 'none';
    # script-src 'self';
    # script-src-attr 'none';
    # style-src 'self' https: 'unsafe-inline';
    # upgrade-insecure-requests;
    # ```
    #
    # This handler has following default configurations set:
    #
    # ```
    # Kemal::Shield.config.csp_on = true
    # Kemal::Shield.config.csp_defaults = true
    # Kemal::Shield.config.csp_directives = Shield::ContentSecurityPolicy::DEFAULT_DIRECTIVES
    # Kemal::Shield.config.csp_report_only = false
    # ```
    class ContentSecurityPolicy < Shield::Handler
      # Default Content-Security-Policy directives
      DEFAULT_DIRECTIVES = {
        "default-src" => ["'self'"],
        "base-uri" => ["'self'"],
        "block-all-mixed-content" => [] of String,
        "font-src" => ["'self'", "https:", "data:"],
        "frame-ancestors" => ["'self'"],
        "img-src" => ["'self'", "data:"],
        "object-src" => ["'none'"],
        "script-src" => ["'self'"],
        "script-src-attr" => ["'none'"],
        "style-src" => ["'self'", "https:", "'unsafe-inline'"],
        "upgrade-insecure-requests" => [] of String
      }

      # Whether the default directives are added to the policy.
      @use_defaults : Bool

      # The directives used to build the policy.
      @directives : Hash(String, Array(String))

      # Whether the header name is Content-Security-Policy-Report-Only or Content-Security-Policy.
      @report_only : Bool

      def initialize(@use_defaults = true, @directives = DEFAULT_DIRECTIVES, @report_only = false); end

      def call(context)
        if Kemal::Shield.config.csp_on
          if @report_only
            context.response.headers["Content-Security-Policy-Report-Only"] = make_header
          else
            context.response.headers["Content-Security-Policy"] = make_header
          end
        end
        call_next(context)
      end

      private def make_header
        header = ""

        serialized_directives = serialize_directives

        if @use_defaults
          DEFAULT_DIRECTIVES.each do |key, value|
            if !serialized_directives.has_key?(key)
              serialized_directives[key] = value
            end
          end
        end

        if serialized_directives.empty?
          raise ArgumentError.new("Content-Security-Policy has no directives. Either set some or disable the header")
        end

        serialized_directives.each do |name, value|
          header += name
          if !value.empty?
            header += " #{value.join(" ")}"
          end
          header += ";"
        end

        return header
      end

      private def serialize_directives
        result = Hash(String, Array(String)).new

        @directives.each do |name, values|
          if name.empty? || /[^a-zA-Z0-9-]/.match(name)
            raise ArgumentError.new("Content-Security-Policy received an invalid directive name #{name}")
          end

          normalized_name = name.downcase

          if result.has_key?(normalized_name)
            raise ArgumentError.new("Content-Security-Policy received a duplicate directive #{normalized_name}")
          end

          if values.empty?
            if normalized_name == "default-src"
              raise ArgumentError.new("Content-Security-Policy needs a default-src")
            end
          else
            values.each do |value|
              if value.empty? || /;|,/.match(value)
                raise ArgumentError.new("Content-Security-Policy received an invalid directive value for #{normalized_name}")
              end
            end
          end

          result[normalized_name] = values
        end

        return result
      end
    end
  end
end
