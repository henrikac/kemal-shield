module Kemal::Shield
  class Config
    INSTANCE = self.new

    @cross_origin_embedder_policy : Bool
    @cross_origin_opener_policy : String
    @cross_origin_resource_policy : String
    @expect_ct : Bool
    @hide_powered_by : Bool
    @no_sniff : Bool
    @origin_agent_cluster : Bool
    @referrer_policy : String
    @strict_transport_security : Bool
    @x_dns_prefetch_control : Bool
    @x_download_options : Bool
    @x_frame_options : String
    @x_permitted_cross_domain_policies : String
    @x_xss_protection : Bool

    property cross_origin_embedder_policy
    property expect_ct
    property hide_powered_by
    property no_sniff
    property origin_agent_cluster
    property strict_transport_security
    property x_dns_prefetch_control
    property x_download_options
    property x_xss_protection

    getter cross_origin_opener_policy
    getter cross_origin_resource_policy
    getter referrer_policy
    getter x_frame_options
    getter x_permitted_cross_domain_policies

    def initialize
      @cross_origin_embedder_policy = true
      @cross_origin_opener_policy = "same-origin"
      @cross_origin_resource_policy = "same-origin"
      @expect_ct = true
      @hide_powered_by = true
      @no_sniff = true
      @origin_agent_cluster = true
      @referrer_policy = "no-referrer"
      @strict_transport_security = true
      @x_dns_prefetch_control = false
      @x_download_options = true
      @x_frame_options = "SAMEORIGIN"
      @x_permitted_cross_domain_policies = "none"
      @x_xss_protection = false
    end

    def cross_origin_opener_policy=(policy : String)
      allowed_policies = [
        "same-origin",
        "same-origin-allow-popups",
        "unsafe-none"
      ]

      if !allowed_policies.includes?(policy)
        raise ArgumentError.new("Cross-Origin-Opener-Policy does not support the #{policy} policy")
      end

      @cross_origin_opener_policy = policy
    end

    def cross_origin_resource_policy=(policy : String)
      allowed_policies = [
        "same-origin",
        "same-site",
        "cross-origin"
      ]

      if !allowed_policies.includes?(policy)
        raise ArgumentError.new("Cross-Origin-Resource-Policy does not support the #{policy} policy")
      end

      @cross_origin_resource_policy = policy
    end

    def referrer_policy=(tokens : Array(String))
      allowed_tokens = [
        "no-referrer",
        "no-referrer-when-downgrade",
        "same-origin",
        "origin",
        "strict-origin",
        "origin-when-cross-origin",
        "strict-origin-when-cross-origin",
        "unsafe-url",
        ""
      ]

      if tokens.empty?
        raise ArgumentError.new("Referrer-Policy received no policy tokens")
      end

      seen = Set(String).new
      tokens.each do |token|
        if !allowed_tokens.includes?(token)
          raise ArgumentError.new("Referrer-Policy received an unexpected policy token #{token}")
        elsif seen.includes?(token)
          raise ArgumentError.new("Referrer-Policy received a duplicate policy token #{token}")
        end
        seen << token
      end

      @referrer_policy = tokens.join(",")
    end

    def x_frame_options=(value : String)
      frame_options = ["SAMEORIGIN", "SAME-ORIGIN", "DENY", "ALLOW-FROM"]
      normalized_value = value.upcase

      if !frame_options.includes?(normalized_value)
        raise ArgumentError.new("Invalid X-Frame-Options action: \"#{normalized_value}\"")
      end

      if normalized_value == "ALLOW-FROM"
        raise ArgumentError.new("X-Frame-Options no longer supports `ALLOW-FROM` due to poor browser support")
      end

      @x_frame_options = normalized_value == "SAME-ORIGIN" ? "SAMEORIGIN" : normalized_value
    end

    def x_permitted_cross_domain_policies=(value : String)
      allowed_policies = ["none", "master-only", "by-content-type", "all"]

      if !allowed_policies.includes?(value)
        raise ArgumentError.new("X-Permitted-Cross-Domain-Policies does not support \"#{value}\"")
      end

      @x_permitted_cross_domain_policies = value
    end
  end

  def self.config
    yield Config::INSTANCE
  end

  def self.config
    Config::INSTANCE
  end
end
