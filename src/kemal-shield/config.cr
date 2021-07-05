module Kemal::Shield
  class Config
    INSTANCE = self.new

    # Whether the Content-Security-Policy is turned on or off.
    @csp_on : Bool

    # Whether the default directives are added to the policy.
    @csp_defaults : Bool

    # The directives used to build the policy.
    @csp_directives : Hash(String, Array(String))

    # Whether the header name is Content-Security-Policy-Report-Only
    # or Content-Security-Policy.
    @csp_report_only : Bool

    # Whether the Cross-Origin-Embedder-Policy header should be set.
    @coep_on : Bool

    # Whether the Cross-Origin-Opener-Policy header should be set.
    @coop_on : Bool

    # The Cross-Origin-Opener-Policy
    @coop : String

    # Whether the Cross-Origin-Resource-Policy header should be set.
    @corp_on : Bool

    # The Cross-Origin-Resource-Policy
    @corp : String

    # Whether the Expect-CT header should be set.
    @expect_ct : Bool

    # The number of seconds which the user agent should regard the host of
    # the received message as a known Expect-CT host.
    @expect_ct_max_age : Int32

    # Whether the user agent should enforce compliance with the Certificate Transparency policy
    # and refuse future connections that violate its Certificate Transparency policy.
    @expect_ct_enforce : Bool

    # The URI where the user agent should report Expect-CT failures.
    @expect_ct_report_uri : String

    # Whether the X-Powered-By header should be hidden.
    @hide_powered_by : Bool

    # Whether to set the X-Content-Type-Options header.
    @no_sniff : Bool

    # Whether to set the Origin-Agent-Cluster header.
    @oac : Bool

    # Whether to set the Referrer-Policy header.
    @referrer_on : Bool

    # The Referrer-Policy.
    @referrer_policy : Array(String)

    # Whether to set the Strict-Transport-Security header.
    @sts_on : Bool
    
    # The number of seconds that the browser should remember that a site is only to be accessed using HTTPS.
    @sts_max_age : Int32

    # Whether the browser should remember that a site's subdomains should only be accessed using HTTPS.
    @sts_include_sub : Bool

    # :nodoc:
    @sts_preload : Bool

    # Whether to set the X-DNS-Prefetch-Control header.
    @x_dns_prefetch_control_on : Bool

    # Whether to enable/disable DNS prefetching.
    @x_dns_prefetch_control : Bool

    # Whether to set the X-Download-Options header.
    @x_download_options : Bool

    # Whether to set the X-Frame-Options header.
    @x_frame_options_on : Bool

    # The X-Frame-Options directive.
    @x_frame_options : String

    # Whether to set the X-Permitted-Cross-Domain-Policies header.
    @x_permitted_cross_domain_policies_on : Bool

    # The X-Permitted-Cross-Domain-Polices directive.
    @x_permitted_cross_domain_policies : String

    # Whether to set the X-XSS-Protection header.
    @x_xss_protection : Bool

    property csp_on
    property csp_defaults
    property csp_directives
    property csp_report_only
    property coep_on
    property coop_on
    property coop
    property corp_on
    property corp
    property expect_ct
    property expect_ct_max_age
    property expect_ct_enforce
    property expect_ct_report_uri
    property hide_powered_by
    property no_sniff
    property oac
    property referrer_on
    property referrer_policy
    property sts_on
    property sts_max_age
    property sts_include_sub
    property sts_preload
    property x_dns_prefetch_control_on
    property x_dns_prefetch_control
    property x_download_options
    property x_frame_options_on
    property x_frame_options
    property x_permitted_cross_domain_policies_on
    property x_permitted_cross_domain_policies
    property x_xss_protection

    def initialize
      @csp_on = true
      @csp_defaults = true
      @csp_directives = Shield::ContentSecurityPolicy::DEFAULT_DIRECTIVES
      @csp_report_only = false
      @coep_on = true
      @coop_on = true
      @coop = "same-origin"
      @corp_on = true
      @corp = "same-origin"
      @expect_ct = true
      @expect_ct_max_age = 0
      @expect_ct_enforce = false
      @expect_ct_report_uri = ""
      @hide_powered_by = true
      @no_sniff = true
      @oac = true
      @referrer_on = true
      @referrer_policy = ["no-referrer"]
      @sts_on = true
      @sts_max_age = Shield::StrictTransportSecurity::DEFAULT_MAX_AGE
      @sts_include_sub = true
      @sts_preload = false
      @x_dns_prefetch_control_on = true
      @x_dns_prefetch_control = false
      @x_download_options = true
      @x_frame_options_on = true
      @x_frame_options = "SAMEORIGIN"
      @x_permitted_cross_domain_policies_on = true
      @x_permitted_cross_domain_policies = "none"
      @x_xss_protection = false
    end
  end

  def self.config
    yield Config::INSTANCE
  end

  def self.config
    Config::INSTANCE
  end
end
