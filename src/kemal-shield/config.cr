module Kemal::Shield
  class Config
    INSTANCE = self.new

    @hide_powered_by : Bool
    @no_sniff : Bool
    @x_dns_prefetch_control_on : Bool
    @x_download_options_on : Bool
    @x_frame_options : String
    @x_permitted_cross_domain_policies : String
    @x_xss_protection_off : Bool

    property hide_powered_by
    property no_sniff
    property x_dns_prefetch_control_on
    property x_download_options_on
    property x_xss_protection_off

    getter x_frame_options
    getter x_permitted_cross_domain_policies

    def initialize
      @hide_powered_by = true
      @no_sniff = true
      @x_dns_prefetch_control_on = false
      @x_download_options_on = true
      @x_frame_options = "SAMEORIGIN"
      @x_permitted_cross_domain_policies = "none"
      @x_xss_protection_off = true
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
