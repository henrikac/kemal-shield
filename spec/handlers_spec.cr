require "./spec_helper"

describe "Kemal::Shield" do
  before_each do
    get "/" do
      "GET"
    end
  end

  describe "::ContentSecurityPolicy" do
    after_each do
      Kemal::Shield.config.csp_on = true
    end

    it "has default policy" do
      add_handler Kemal::Shield::ContentSecurityPolicy.new
      request = HTTP::Request.new("GET", "/")

      expected_policy = "default-src 'self';base-uri 'self';block-all-mixed-content;\
      font-src 'self' https: data:;frame-ancestors 'self';img-src 'self' data:;\
      object-src 'none';script-src 'self';script-src-attr 'none';style-src 'self' https: 'unsafe-inline';\
      upgrade-insecure-requests;"

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Content-Security-Policy").should be_true
      client_response.headers["Content-Security-Policy"].should eq expected_policy
    end

    it "adds default directives if not in custom directives and use_defaults is true" do
      add_handler Kemal::Shield::ContentSecurityPolicy.new(directives: {"default-src" => ["'self'"]})
      request = HTTP::Request.new("GET", "/")

      expected_policy = "default-src 'self';base-uri 'self';block-all-mixed-content;\
      font-src 'self' https: data:;frame-ancestors 'self';img-src 'self' data:;\
      object-src 'none';script-src 'self';script-src-attr 'none';style-src 'self' https: 'unsafe-inline';\
      upgrade-insecure-requests;"

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Content-Security-Policy").should be_true
      client_response.headers["Content-Security-Policy"].should eq expected_policy
    end

    it "does not add default directives if use_defaults is false" do
      add_handler Kemal::Shield::ContentSecurityPolicy.new(
        use_defaults: false,
        directives: {"default-src" => ["'self'"]}
      )
      request = HTTP::Request.new("GET", "/")

      expected_policy = "default-src 'self';"

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Content-Security-Policy").should be_true
      client_response.headers["Content-Security-Policy"].should eq expected_policy
    end

    it "will not set the Content-Security-Policy header is csp_on == false" do
      Kemal::Shield.config.csp_on = false

      add_handler Kemal::Shield::ContentSecurityPolicy.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Content-Security-Policy").should be_false
    end

    it "raises an ArgumentError if directive name is an empty string" do
      handler = Kemal::Shield::ContentSecurityPolicy.new(directives: {"" => ["'self'"]})
      request = HTTP::Request.new("GET", "/")

      expect_raises(ArgumentError) do
        process_request(request, handler)
      end
    end

    it "raises an ArgumentError if directive name matches /[^a-zA-Z0-9-]/" do
      handler = Kemal::Shield::ContentSecurityPolicy.new(directives: {"default_src" => ["'self'"]})
      request = HTTP::Request.new("GET", "/")

      expect_raises(ArgumentError) do
        process_request(request, handler)
      end
    end

    it "raises an ArgumentError if dublicate directives" do
      handler = Kemal::Shield::ContentSecurityPolicy.new(directives: {
        "default-src" => ["'self'"],
        "DEFAULT-SRC" => ["'self'"]
      })
      request = HTTP::Request.new("GET", "/")


      expect_raises(ArgumentError) do
        process_request(request, handler)
      end
    end

    it "raises an ArgumentError if default-src has no value" do
      handler = Kemal::Shield::ContentSecurityPolicy.new(directives: {"default-src" => [] of String})
      request = HTTP::Request.new("GET", "/")

      expect_raises(ArgumentError) do
        process_request(request, handler)
      end
    end

    it "raises an ArgumentError if a value contains either ; or ," do
      test_directives = [
        {"default-src" => ["'self';"]},
        {"default-src" => ["'self',"]}
      ]

      test_directives.each do |test_directive|
        handler = Kemal::Shield::ContentSecurityPolicy.new(directives: test_directive)
        request = HTTP::Request.new("GET", "/")

        expect_raises(ArgumentError) do
          process_request(request, handler)
        end
      end
    end
  end

  describe "::CrossOriginEmbedderPolicy" do
    after_each do
      Kemal::Shield.config.coep_on = true
    end

    it "is set to require-corp" do
      add_handler Kemal::Shield::CrossOriginEmbedderPolicy.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Cross-Origin-Embedder-Policy").should be_true
      client_response.headers["Cross-Origin-Embedder-Policy"].should eq "require-corp"
    end

    it "will not set the Cross-Origin-Embedder-Policy header if coep_on == false" do
      Kemal::Shield.config.coep_on = false

      add_handler Kemal::Shield::CrossOriginEmbedderPolicy.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Cross-Origin-Embedder-Policy").should be_false
    end
  end

  describe "::CrossOriginOpenerPolicy" do
    after_each do
      Kemal::Shield.config.coop_on = true
    end

    it "is set to same-origin" do
      add_handler Kemal::Shield::CrossOriginOpenerPolicy.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Cross-Origin-Opener-Policy").should be_true
      client_response.headers["Cross-Origin-Opener-Policy"].should eq "same-origin"
    end

    it "will not set the Cross-Origin-Opener-Policy header if coop_on == false" do
      Kemal::Shield.config.coop_on = false

      add_handler Kemal::Shield::CrossOriginOpenerPolicy.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Cross-Origin-Opener-Policy").should be_false
    end

    it "raises an ArgumentError if invalid policy" do
      expect_raises(ArgumentError) do
        Kemal::Shield::CrossOriginOpenerPolicy.new("invalid-policy")
      end
    end
  end

  describe "::CrossOriginResourcePolicy" do
    after_each do
      Kemal::Shield.config.corp_on = true
    end

    it "is set to same-origin" do
      add_handler Kemal::Shield::CrossOriginResourcePolicy.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Cross-Origin-Resource-Policy").should be_true
      client_response.headers["Cross-Origin-Resource-Policy"].should eq "same-origin"
    end

    it "will not set the Cross-Origin-Resource-Policy header if corp_on == false" do
      Kemal::Shield.config.corp_on = false

      add_handler Kemal::Shield::CrossOriginResourcePolicy.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Cross-Origin-Resource-Policy").should be_false
    end

    it "raises an ArgumentError if invalid policy" do
      expect_raises(ArgumentError) do
        Kemal::Shield::CrossOriginResourcePolicy.new("invalid-policy")
      end
    end
  end

  describe "::ExpectCT" do
    after_each do
      Kemal::Shield.config.expect_ct = true
    end

    it "has max-age=0 by default" do
      add_handler Kemal::Shield::ExpectCT.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Expect-CT").should be_true
      client_response.headers["Expect-CT"].should eq "max-age=0"
    end

    it "can turn on enforce" do
      add_handler Kemal::Shield::ExpectCT.new(enforce: true)
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Expect-CT").should be_true
      client_response.headers["Expect-CT"].should eq "max-age=0, enforce"
    end

    it "can add report_uri" do
      add_handler Kemal::Shield::ExpectCT.new(report_uri: "https://example.com/report")
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Expect-CT").should be_true
      client_response.headers["Expect-CT"].should eq "max-age=0, report-uri=https://example.com/report"
    end

    it "will not set the Expect-CT header if expect_ct == false" do
      Kemal::Shield.config.expect_ct = false

      add_handler Kemal::Shield::ExpectCT.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Expect-CT").should be_false
    end

    it "raises an ArgumentError if max_age if less than 0" do
      expect_raises(ArgumentError) do
        Kemal::Shield::ExpectCT.new(max_age: -1)
      end
    end
  end

  describe "::OriginAgentCluster" do
    after_each do
      Kemal::Shield.config.oac = true
    end

    it "is on by default" do
      add_handler Kemal::Shield::OriginAgentCluster.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Origin-Agent-Cluster").should be_true
      client_response.headers["Origin-Agent-Cluster"].should eq "?1"
    end

    it "will not set the Origin-Agent-Cluster header if oac == false" do
      Kemal::Shield.config.oac = false

      add_handler Kemal::Shield::OriginAgentCluster.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Origin-Agent-Cluster").should be_false
    end
  end

  describe "::ReferrerPolicy" do
    after_each do
      Kemal::Shield.config.referrer_on = true
    end

    it "is set to no-referrer by default" do
      add_handler Kemal::Shield::ReferrerPolicy.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Referrer-Policy").should be_true
      client_response.headers["Referrer-Policy"].should eq "no-referrer"
    end

    it "should set custom policy correctly" do
      tests = [
        {tokens: ["origin", "strict-origin", "same-origin"], expected: "origin,strict-origin,same-origin"},
        {tokens: ["no-referrer"], expected: "no-referrer"},
        {tokens: ["no-referrer", "no-referrer-when-downgrade"], expected: "no-referrer,no-referrer-when-downgrade"}
      ]

      tests.each do |test|
        Kemal.config.clear
        Kemal::RouteHandler::INSTANCE.routes = Radix::Tree(Kemal::Route).new

        add_handler Kemal::Shield::ReferrerPolicy.new(test[:tokens])
        request = HTTP::Request.new("GET", "/")

        client_response = call_request_on_app(request)
        client_response.headers.has_key?("Referrer-Policy").should be_true
        client_response.headers["Referrer-Policy"].should eq test[:expected]
      end
    end

    it "will not set the Referrer-Policy header if referrer_on == false" do
      Kemal::Shield.config.referrer_on = false

      add_handler Kemal::Shield::ReferrerPolicy.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Referrer-Policy").should be_false
    end

    it "raises an ArgumentError if tokens are empty" do
      expect_raises(ArgumentError) do
        Kemal::Shield::ReferrerPolicy.new([] of String)
      end
    end

    it "raises an ArgumentError if tokens contains invalid tokens" do
      expect_raises(ArgumentError) do
        Kemal::Shield::ReferrerPolicy.new(["invalid-token"])
      end
    end

    it "raises an ArgumentError if tokens contains dublicates" do
      expect_raises(ArgumentError) do
        Kemal::Shield::ReferrerPolicy.new(["no-referrer", "no-referrer"])
      end
    end
  end
  
  describe "::StrictTransportSecurity" do
    after_each do
      Kemal::Shield.config.sts_on = true
    end

    it "has max-age and includeSubDomains set by default" do
      add_handler Kemal::Shield::StrictTransportSecurity.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Strict-Transport-Security").should be_true
      client_response.headers["Strict-Transport-Security"].should eq "max-age=15552000; includeSubDomains"
    end

    it "can turn off includeSubDomains" do
      add_handler Kemal::Shield::StrictTransportSecurity.new(include_sub_domains: false)
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Strict-Transport-Security").should be_true
      client_response.headers["Strict-Transport-Security"].should eq "max-age=15552000"
    end

    it "can turn on preload" do
      add_handler Kemal::Shield::StrictTransportSecurity.new(preload: true)
      request = HTTP::Request.new("GET", "/")

      expected = "max-age=15552000; includeSubDomains; preload"

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Strict-Transport-Security").should be_true
      client_response.headers["Strict-Transport-Security"].should eq expected
    end

    it "will not set the Strict-Transport-Security header if sts_on == false" do
      Kemal::Shield.config.sts_on = false

      add_handler Kemal::Shield::StrictTransportSecurity.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Strict-Transport-Security").should be_false
    end

    it "raises an ArgumentError if max_age is less than 0" do
      expect_raises(ArgumentError) do
        Kemal::Shield::StrictTransportSecurity.new(max_age: -1)
      end
    end
  end

  describe "::XContentTypeOptions" do
    after_each do
      Kemal::Shield.config.no_sniff = true
    end

    it "is set to nosniff by default" do
      add_handler Kemal::Shield::XContentTypeOptions.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("X-Content-Type-Options").should be_true
      client_response.headers["X-Content-Type-Options"].should eq "nosniff"
    end

    it "will not set the X-Content-Type-Options header if no_sniff == false" do
      Kemal::Shield.config.no_sniff = false

      add_handler Kemal::Shield::XContentTypeOptions.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("X-Content-Type-Options").should be_false
    end
  end

  describe "::XDNSPrefetchControl" do
    after_each do
      Kemal::Shield.config.x_dns_prefetch_control_on = true
      Kemal::Shield.config.x_dns_prefetch_control = false
    end

    it "is set to off by default" do
      add_handler Kemal::Shield::XDNSPrefetchControl.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("X-DNS-Prefetch-Control").should be_true
      client_response.headers["X-DNS-Prefetch-Control"].should eq "off"
    end

    it "can be set to on" do
      Kemal::Shield.config.x_dns_prefetch_control = true
      add_handler Kemal::Shield::XDNSPrefetchControl.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("X-DNS-Prefetch-Control").should be_true
      client_response.headers["X-DNS-Prefetch-Control"].should eq "on"
    end

    it "will not set the X-DNS-Prefetch-Control header if x_dns_prefetch_control_on == false" do
      Kemal::Shield.config.x_dns_prefetch_control_on = false

      add_handler Kemal::Shield::XDNSPrefetchControl.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("X-DNS-Prefetch-Control").should be_false
    end
  end

  describe "::XDownloadOptions" do
    after_each do
      Kemal::Shield.config.x_download_options = true
    end

    it "is set to noopen" do
      add_handler Kemal::Shield::XDownloadOptions.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("X-Download-Options").should be_true
      client_response.headers["X-Download-Options"].should eq "noopen"
    end

    it "will not set the X-Download-Options header if x_download_options == false" do
      Kemal::Shield.config.x_download_options = false

      add_handler Kemal::Shield::XDownloadOptions.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("X-Download-Options").should be_false
    end
  end

  describe "::XFrameOptions" do
    after_each do
      Kemal::Shield.config.x_frame_options_on = true
    end

    it "is set to SAMEORIGIN" do
      add_handler Kemal::Shield::XFrameOptions.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("X-Frame-Options").should be_true
      client_response.headers["X-Frame-Options"].should eq "SAMEORIGIN"
    end

    it "should set option correctly" do
      tests = [
        {input: "SAME-ORIGIN", expected: "SAMEORIGIN"},
        {input: "DENY", expected: "DENY"},
        {input: "saMe-ORIgiN", expected: "SAMEORIGIN"}
      ]

      tests.each do |test|
        Kemal.config.clear
        Kemal::RouteHandler::INSTANCE.routes = Radix::Tree(Kemal::Route).new

        add_handler Kemal::Shield::XFrameOptions.new(test[:input])
        request = HTTP::Request.new("GET", "/")

        client_response = call_request_on_app(request)
        client_response.headers.has_key?("X-Frame-Options").should be_true
        client_response.headers["X-Frame-Options"].should eq test[:expected]
      end
    end

    it "will not set the X-Frame-Options header if x_frame_options_on == false" do
      Kemal::Shield.config.x_frame_options_on = false

      add_handler Kemal::Shield::XFrameOptions.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("X-Frame-Options").should be_false
    end

    it "should raise an ArgumentError if invalid option" do
      expect_raises(ArgumentError) do
        Kemal::Shield::XFrameOptions.new("INVALID")
      end
    end

    it "should raise an ArgumentError if option is set to ALLOW-FROM" do
      expect_raises(ArgumentError) do
        Kemal::Shield::XFrameOptions.new("ALLOW-FROM")
      end
    end
  end

  describe "::XPermittedCrossDomainPolicies" do
    after_each do
      Kemal::Shield.config.x_permitted_cross_domain_policies_on = true
    end

    it "is set to none by default" do
      add_handler Kemal::Shield::XPermittedCrossDomainPolicies.new
      request = HTTP::Request.new("GET", "/")
      
      client_response = call_request_on_app(request)
      client_response.headers.has_key?("X-Permitted-Cross-Domain-Policies").should be_true
      client_response.headers["X-Permitted-Cross-Domain-Policies"].should eq "none"
    end

    it "should set policy correctly" do
      policies = ["none", "master-only", "by-content-type", "all"]

      policies.each do |policy|
        Kemal.config.clear
        Kemal::RouteHandler::INSTANCE.routes = Radix::Tree(Kemal::Route).new
        
        add_handler Kemal::Shield::XPermittedCrossDomainPolicies.new(policy)
        request = HTTP::Request.new("GET", "/")

        client_response = call_request_on_app(request)
        client_response.headers.has_key?("X-Permitted-Cross-Domain-Policies").should be_true
        client_response.headers["X-Permitted-Cross-Domain-Policies"].should eq policy
      end
    end

    it "will not set the X-Permitted-Cross-Domain-Policies header if x_permitted_cross_domain_policies_on == false" do
      Kemal::Shield.config.x_permitted_cross_domain_policies_on = false

      add_handler Kemal::Shield::XPermittedCrossDomainPolicies.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("X-Permitted-Cross-Domain-Policies").should be_false
    end

    it "should raise an ArgumentError if invalid policy" do
      expect_raises(ArgumentError) do
        Kemal::Shield::XPermittedCrossDomainPolicies.new("invalid")
      end
    end
  end

  describe "::XPoweredBy" do
    after_each do
      Kemal::Shield.config.hide_powered_by = true
    end

    it "should remove x-powered-by header" do
      add_handler Kemal::Shield::XPoweredBy.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("X-Powered-By").should be_false
    end

    it "has default behaviour if hide_powered_by is false" do
      Kemal::Shield.config.hide_powered_by = false
      add_handler Kemal::Shield::XPoweredBy.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("X-Powered-By").should be_true
      client_response.headers["X-Powered-By"].should eq "Kemal"
    end
  end

  describe "::XXSSProtection" do
    it "should set x-xss-protection header to 0" do
      add_handler Kemal::Shield::XXSSProtection.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("X-XSS-Protection").should be_true
      client_response.headers["X-XSS-Protection"].should eq "0"
    end
  end
end
