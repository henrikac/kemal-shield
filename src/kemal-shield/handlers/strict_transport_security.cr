require "kemal"

# `Kemal::Shield::StrictTransportSecurity` is a handler that sets the Strict-Transport-Security HTTP header.
#
# Default values:
# ```
# Kemal::Shield.config.sts_max_age = 180 * 24 * 60 * 60
# Kemal::Shield.config.sts_include_sub = true
# Kemal::Shield.config.sts_preload = false
# ```
#
# This handler can be turned of by setting
# ```
# Kemal::Shield.config.sts_on = false
# ```
class Kemal::Shield::StrictTransportSecurity < Kemal::Handler
  # The default *max_age* (15_552_000 seconds).
  DEFAULT_MAX_AGE = 180 * 24 * 60 * 60

  # The number of seconds that the browser should remember that a site is only to be accessed using HTTPS.
  @max_age : Int32

  # Whether the browser should remember that a site's subdomains should only be accessed using HTTPS.
  @include_sub_domains : Bool

  # :nodoc:
  @preload : Bool

  # Creates a new `Kemal::Shield::StrictTransportSecurity` handler.
  #
  # An `ArgumentError` is raise if *max_age* is less than 0.
  def initialize
    @max_age = Kemal::Shield.config.sts_max_age
    @include_sub_domains = Kemal::Shield.config.sts_include_sub
    @preload = Kemal::Shield.config.sts_preload

    if @max_age < 0
      raise ArgumentError.new("Strict-Transport-Security max-age must be greater than 0")
    end
  end

  def call(context)
    if Kemal::Shield.config.sts_on
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
