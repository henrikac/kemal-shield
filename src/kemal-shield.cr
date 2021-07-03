require "kemal"
require "./**"

# `Kemal::Shield` is a module that contains a collection of Kemal handlers.
# These handlers sets/unsets different HTTP response headers adding an extra
# layer of protection.
#
# ```
# Kemal::Shield::All.new # => Adds all the handlers
# ```
#
# It is also possible to add just the handlers that you are interested in.
#
# ```
# add_handler Kemal::Shield::XPoweredBy.new # => Removes the X-Powered-By header
# add_handler Kemal::Shield::XXSSProtection.new # => Sets X-XSS-Protection to "0"
# ```
#
# The different headers can be configured in the same way as Kemal:
#
# ```
# Kemal::Shield.config do |config|
#   config.csp_on = true
#   config.hide_powered_by = true
#   config.no_sniff = true
#   config.referrer_policy = "no-referrer"
#   config.x_xss_protection = false
# end
# ```
module Kemal::Shield
  VERSION = "0.1.0"

  class All
    def initialize
      add_handler ContentSecurityPolicy.new
      add_handler CrossOriginEmbedderPolicy.new
      add_handler CrossOriginOpenerPolicy.new
      add_handler CrossOriginResourcePolicy.new
      add_handler ExpectCT.new
      add_handler OriginAgentCluster.new
      add_handler ReferrerPolicy.new
      add_handler StrictTransportSecurity.new
      add_handler XContentTypeOptions.new
      add_handler XDNSPrefetchControl.new
      add_handler XDownloadOptions.new
      add_handler XFrameOptions.new
      add_handler XPermittedCrossDomainPolicies.new
      add_handler XPoweredBy.new
      add_handler XXSSProtection.new
    end
  end
end
