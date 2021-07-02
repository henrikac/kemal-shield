require "kemal"

class Kemal::Shield::StrictTransportSecurity < Kemal::Handler
  DEFAULT_MAX_AGE = 180 * 24 * 60 * 60

  @max_age : Int32
  @include_sub_domains : Bool
  @preload : Bool

  def initialize(@max_age = DEFAULT_MAX_AGE, @include_sub_domains = true, @preload = false)
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
