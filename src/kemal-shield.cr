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
    HANDLERS = [] of Shield::Handler.class

    # Adds a `Kemal::Shield::Handler`.
    #
    # ```
    # class CustomHandler < Kemal::Shield::Handler
    #   def call(context)
    #     # code ...
    #     call_next context
    #   end
    # end
    #
    # Kemal::Shield.add_handler CustomHandler.new
    # ```
    #
    # A `Kemal::Shield::DublicateHandlerError` is raised if dublicate handlers
    # are added.
    #
    # ```
    # Kemal::Shield.add_handler CustomHandler.new # => okay
    # Kemal::Shield.add_handler CustomHandler.new # => raises DublicateHandlerError
    # ```
    def self.add_handler(handler : Shield::Handler)
      if HANDLERS.includes?(handler.class)
        raise Shield::DublicateHandlerError.new(handler)
      end
      HANDLERS << handler.class
      Kemal.config.add_handler handler
    end

    # Removes a `Kemal::Shield::Handler`.
    #
    # Returns the removed handler if found, otherwise `nil`.
    #
    # ```
    # Kemal::Shield.activate
    #
    # Kemal::Shield.remove_handler Kemal::Shield::ExpectCT # => Kemal::Shield::ExpectCT object
    # Kemal::Shield.remove_handler Kemal::Shield::ExpectCT # => nil
    # ```
    def self.remove_handler(handler : Shield::Handler.class)
      if HANDLERS.includes?(handler)
        HANDLERS.delete(handler)
        Kemal.config.handlers.each do |h|
          if h.class == handler
            return Kemal.config.handlers.delete(h)
          end
        end
      end
      return nil
    end

    # Removes all `Kemal::Shield::Handler`.
    #
    # ```
    # Kemal::Shield.deactivate
    # ```
    def self.deactivate
      non_shield_handlers = [] of HTTP::Handler

      Kemal.config.handlers.each do |handler|
        if !HANDLERS.includes?(handler.class)
          non_shield_handlers << handler
        end
      end
      HANDLERS.clear
      Kemal.config.handlers = non_shield_handlers
    end

    # Adds a collection of `Kemal::Shield::Handler`.
    #
    # ```
    # Kemal::Shield.activate
    # ```
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
