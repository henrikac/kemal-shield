require "kemal"
require "./**"

# TODO: Write ocumentation for `Kemal::Shield`
module Kemal::Shield
  VERSION = "0.1.0"

  class All
    def initialize
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
