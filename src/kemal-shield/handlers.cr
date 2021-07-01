require "kemal"

module Kemal::Shield
  class XContentTypeOptions < Kemal::Handler
    def call(context)
      if Kemal::Shield.config.no_sniff
        context.response.headers["X-Content-Type-Options"] = "nosniff"
      end
      call_next(context)
    end
  end

  class XDNSPrefetchControl < Kemal::Handler
    def call(context)
      value = Kemal::Shield.config.x_dns_prefetch_control_on ? "on" : "off"
      context.response.headers["X-DNS-Prefetch-Control"] = value
      call_next(context)
    end
  end

  class XDownloadOptions < Kemal::Handler
    def call(context)
      if Kemal::Shield.config.x_download_options_on
        context.response.headers["X-Download-Options"] = "noopen"
      end
      call_next(context)
    end
  end

  class XFrameOptions < Kemal::Handler
    def call(context)
      context.response.headers["X-Frame-Options"] = Kemal::Shield.config.x_frame_options
      call_next(context)
    end
  end

  class XPermittedCrossDomainPolicies < Kemal::Handler
    def call(context)
      policies = Kemal::Shield.config.x_permitted_cross_domain_policies
      context.response.headers["X-Permitted-Cross-Domain-Policies"] = policies
      call_next(context)
    end
  end

  class XPoweredBy < Kemal::Handler
    def call(context)
      if Kemal::Shield.config.hide_powered_by
        context.response.headers.delete("X-Powered-By")
      end
      call_next(context)
    end
  end

  class XXSSProtection < Kemal::Handler
    def call(context)
      if Kemal::Shield.config.x_xss_protection_off
        context.response.headers["X-XSS-Protection"] = "0"
      end
      call_next(context)
    end
  end
end
