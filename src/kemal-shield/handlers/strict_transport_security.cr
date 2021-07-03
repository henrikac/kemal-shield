require "kemal"

# `Kemal::Shield::StrictTransportSecurity` is a handler that sets the Strict-Transport-Security HTTP header.
#
# Default values:
# ```
# Kemal::Shield.config.strict_transport_security_max_age = 180 * 24 * 60 * 60
# Kemal::Shield.config.strict_transport_security_include_sub = true
# Kemal::Shield.config.strict_transport_security_preload = false
# ```
#
# This handler can be turned of by setting
# ```
# Kemal::Shield.config.strict_transport_security = false
# ```
class Kemal::Shield::StrictTransportSecurity < Kemal::Handler
  DEFAULT_MAX_AGE = 180 * 24 * 60 * 60

  @max_age : Int32
  @include_sub_domains : Bool
  @preload : Bool

  def initialize
    @max_age = Kemal::Shield.config.strict_transport_security_max_age
    @include_sub_domains = Kemal::Shield.config.strict_transport_security_include_sub
    @preload = Kemal::Shield.config.strict_transport_security_preload

    if @max_age < 0
      raise ArgumentError.new("Strict-Transport-Security max-age must be greater than 0")
    end
  end

  def call(context)
    if Kemal::Shield.config.strict_transport_security
      value = "max-age=#{@max_age}"
      if @include_sub_domains
        value += "; includeSubDomains"
      end
      if @preload
        value += "; preload"
      end
      context.response.headers["Strict-Transport-Security"] = value
    end
    call_next(context)
  end
end
