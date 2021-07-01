require "kemal"

module Kemal::Shield
  class CrossOriginEmbedderPolicy < Kemal::Handler
    def call(context)
      if Kemal::Shield.config.cross_origin_embedder_policy_on
        context.response.headers["Cross-Origin-Embedder-Policy"] = "require-corp"
      end
      call_next(context)
    end
  end

  class CrossOriginOpenerPolicy < Kemal::Handler
    def call(context)
      policy = Kemal::Shield.config.cross_origin_opener_policy
      context.response.headers["Cross-Origin-Opener-Policy"] = policy
      call_next(context)
    end
  end

  class CrossOriginResourcePolicy < Kemal::Handler
    def call(context)
      policy = Kemal::Shield.config.cross_origin_resource_policy
      context.response.headers["Cross-Origin-Resource-Policy"] = policy
      call_next(context)
    end
  end

  class ExpectCT < Kemal::Handler
    @max_age : Int32
    @enforce : Bool
    @report_uri : String

    def initialize(@max_age = 0, @enforce = false, @report_uri = "")
      if @max_age < 0
        raise ArgumentError.new("Expect-CT max-age must be greater than or equal to 0")
      end
    end

    def call(context)
      if Kemal::Shield.config.expect_ct
        value = "max-age=#{@max_age}"
        if @enforce
          value += ", enforce"
        end
        if !@report_uri.empty?
          value += ", report-uri=#{@report_uri}"
        end
        context.response.headers["Expect-CT"] = value
      end
      call_next(context)
    end
  end

  class OriginAgentCluster < Kemal::Handler
    def call(context)
      if Kemal::Shield.config.origin_agent_cluster_on
        context.response.headers["Origin-Agent-Cluster"] = "?1"
      end
      call_next(context)
    end
  end

  class ReferrerPolicy < Kemal::Handler
    def call(context)
      context.response.headers["Referrer-Policy"] = Kemal::Shield.config.referrer_policy
      call_next(context)
    end
  end

  class StrictTransportSecurity < Kemal::Handler
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
      if Kemal::Shield.config.strict_transport_security_on
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
