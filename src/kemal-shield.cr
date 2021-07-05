require "kemal"
require "./**"

module Kemal
  # `Kemal::Shield` is a module that contains a collection of Kemal handlers.
  # These handlers sets/unsets different HTTP response headers adding an extra
  # layer of protection.
  #
  # ```
  # Kemal::Shield.activate # => Adds all the handlers
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
  #   config.referrer_policy = ["no-referrer"]
  #   config.x_xss_protection = false
  # end
  # ```
  module Shield
    def self.activate
      add_handler ContentSecurityPolicy.new(
        config.csp_defaults,
        config.csp_directives,
        config.csp_report_only
      )
      add_handler CrossOriginEmbedderPolicy.new
      add_handler CrossOriginOpenerPolicy.new(config.coop)
      add_handler CrossOriginResourcePolicy.new(config.corp)
      add_handler ExpectCT.new(
        config.expect_ct_max_age,
        config.expect_ct_enforce,
        config.expect_ct_report_uri
      )
      add_handler OriginAgentCluster.new
      add_handler ReferrerPolicy.new(config.referrer_policy)
      add_handler StrictTransportSecurity.new(
        config.sts_max_age,
        config.sts_include_sub,
        config.sts_preload
      )
      add_handler XContentTypeOptions.new
      add_handler XDNSPrefetchControl.new
      add_handler XDownloadOptions.new
      add_handler XFrameOptions.new(config.x_frame_options)
      add_handler XPermittedCrossDomainPolicies.new(config.x_permitted_cross_domain_policies)
      add_handler XPoweredBy.new
      add_handler XXSSProtection.new
    end
  end
end
