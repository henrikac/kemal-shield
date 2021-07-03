require "./spec_helper"

describe "Kemal::Shield" do
  before_each do
    get "/" do
      "GET"
    end
  end

  describe "::ContentSecurityPolicy" do
    after_each do
      Kemal::Shield.config.csp_defaults = true
      Kemal::Shield.config.csp_directives = Kemal::Shield::ContentSecurityPolicy::DEFAULT_DIRECTIVES
      Kemal::Shield.config.csp_report_only = false
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
      Kemal::Shield.config.csp_directives = {"default-src" => ["'self'"]}

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

    it "does not add default directives if use_defaults is false" do
      Kemal::Shield.config.csp_defaults = false
      Kemal::Shield.config.csp_directives = {"default-src" => ["'self'"]}

      add_handler Kemal::Shield::ContentSecurityPolicy.new
      request = HTTP::Request.new("GET", "/")

      expected_policy = "default-src 'self';"

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Content-Security-Policy").should be_true
      client_response.headers["Content-Security-Policy"].should eq expected_policy
    end

    it "raises an ArgumentError if directive name is an empty string" do
      Kemal::Shield.config.csp_directives = {"" => ["'self'"]}

      handler = Kemal::Shield::ContentSecurityPolicy.new
      request = HTTP::Request.new("GET", "/")

      expect_raises(ArgumentError) do
        process_request(request, handler)
      end
    end

    it "raises an ArgumentError if directive name matches /[^a-zA-Z0-9-]/" do
      Kemal::Shield.config.csp_directives = {"default_src" => ["'self'"]}

      handler = Kemal::Shield::ContentSecurityPolicy.new
      request = HTTP::Request.new("GET", "/")

      expect_raises(ArgumentError) do
        process_request(request, handler)
      end
    end

    it "raises an ArgumentError if dublicate directives" do
      Kemal::Shield.config.csp_directives = {
        "default-src" => ["'self'"],
        "DEFAULT-SRC" => ["'self'"]
      }

      handler = Kemal::Shield::ContentSecurityPolicy.new
      request = HTTP::Request.new("GET", "/")


      expect_raises(ArgumentError) do
        process_request(request, handler)
      end
    end

    it "raises an ArgumentError if default-src has no value" do
      Kemal::Shield.config.csp_directives = {"default-src" => [] of String}

      handler = Kemal::Shield::ContentSecurityPolicy.new
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
        Kemal::Shield.config.csp_directives = test_directive

        handler = Kemal::Shield::ContentSecurityPolicy.new
        request = HTTP::Request.new("GET", "/")

        expect_raises(ArgumentError) do
          process_request(request, handler)
        end
      end
    end
  end

  describe "::CrossOriginEmbedderPolicy" do
    it "is set to require-corp" do
      add_handler Kemal::Shield::CrossOriginEmbedderPolicy.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Cross-Origin-Embedder-Policy").should be_true
      client_response.headers["Cross-Origin-Embedder-Policy"].should eq "require-corp"
    end
  end

  describe "::CrossOriginOpenerPolicy" do
    it "is set to same-origin" do
      add_handler Kemal::Shield::CrossOriginOpenerPolicy.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Cross-Origin-Opener-Policy").should be_true
      client_response.headers["Cross-Origin-Opener-Policy"].should eq "same-origin"
    end
  end

  describe "::CrossOriginResourcePolicy" do
    it "is set to same-origin" do
      add_handler Kemal::Shield::CrossOriginResourcePolicy.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Cross-Origin-Resource-Policy").should be_true
      client_response.headers["Cross-Origin-Resource-Policy"].should eq "same-origin"
    end
  end

  describe "::ExpectCT" do
    after_each do
      Kemal::Shield.config.expect_ct = true
      Kemal::Shield.config.expect_ct_max_age = 0
      Kemal::Shield.config.expect_ct_enforce = false
      Kemal::Shield.config.expect_ct_report_uri = ""
    end

    it "has max-age=0 by default" do
      add_handler Kemal::Shield::ExpectCT.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Expect-CT").should be_true
      client_response.headers["Expect-CT"].should eq "max-age=0"
    end

    it "can turn on enforce" do
      Kemal::Shield.config.expect_ct_enforce = true

      add_handler Kemal::Shield::ExpectCT.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Expect-CT").should be_true
      client_response.headers["Expect-CT"].should eq "max-age=0, enforce"
    end

    it "can add report_uri" do
      Kemal::Shield.config.expect_ct_report_uri = "https://example.com/report"

      add_handler Kemal::Shield::ExpectCT.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Expect-CT").should be_true
      client_response.headers["Expect-CT"].should eq "max-age=0, report-uri=https://example.com/report"
    end

    it "raises an ArgumentError if max_age if less than 0" do
      expect_raises(ArgumentError) do
        Kemal::Shield.config.expect_ct_max_age = -1
        Kemal::Shield::ExpectCT.new
      end
    end
  end

  describe "::OriginAgentCluster" do
    it "is on by default" do
      add_handler Kemal::Shield::OriginAgentCluster.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Origin-Agent-Cluster").should be_true
      client_response.headers["Origin-Agent-Cluster"].should eq "?1"
    end
  end

  describe "::ReferrerPolicy" do
    it "is set to no-referrer by default" do
      add_handler Kemal::Shield::ReferrerPolicy.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Referrer-Policy").should be_true
      client_response.headers["Referrer-Policy"].should eq "no-referrer"
    end
  end
  
  describe "::StrictTransportSecurity" do
    after_each do
      Kemal::Shield.config.strict_transport_security = true
      Kemal::Shield.config.strict_transport_security_max_age = Kemal::Shield::StrictTransportSecurity::DEFAULT_MAX_AGE
      Kemal::Shield.config.strict_transport_security_include_sub = true
      Kemal::Shield.config.strict_transport_security_preload = false
    end

    it "has max-age and includeSubDomains set by default" do
      add_handler Kemal::Shield::StrictTransportSecurity.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Strict-Transport-Security").should be_true
      client_response.headers["Strict-Transport-Security"].should eq "max-age=15552000; includeSubDomains"
    end

    it "can turn off includeSubDomains" do
      Kemal::Shield.config.strict_transport_security_include_sub = false

      add_handler Kemal::Shield::StrictTransportSecurity.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Strict-Transport-Security").should be_true
      client_response.headers["Strict-Transport-Security"].should eq "max-age=15552000"
    end

    it "can turn on preload" do
      Kemal::Shield.config.strict_transport_security_preload = true

      add_handler Kemal::Shield::StrictTransportSecurity.new
      request = HTTP::Request.new("GET", "/")

      expected = "max-age=15552000; includeSubDomains; preload"

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("Strict-Transport-Security").should be_true
      client_response.headers["Strict-Transport-Security"].should eq expected
    end

    it "raises an ArgumentError if max_age is less than 0" do
      expect_raises(ArgumentError) do
        Kemal::Shield.config.strict_transport_security_max_age = -1

        Kemal::Shield::StrictTransportSecurity.new
      end
    end
  end

  describe "::XContentTypeOptions" do
    it "is set to nosniff by default" do
      add_handler Kemal::Shield::XContentTypeOptions.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("X-Content-Type-Options").should be_true
      client_response.headers["X-Content-Type-Options"].should eq "nosniff"
    end
  end

  describe "::XDNSPrefetchControl" do
    after_each do
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
  end

  describe "::XDownloadOptions" do
    it "is set to noopen" do
      add_handler Kemal::Shield::XDownloadOptions.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("X-Download-Options").should be_true
      client_response.headers["X-Download-Options"].should eq "noopen"
    end
  end

  describe "::XFrameOptions" do
    it "is set to SAMEORIGIN" do
      add_handler Kemal::Shield::XFrameOptions.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("X-Frame-Options").should be_true
      client_response.headers["X-Frame-Options"].should eq "SAMEORIGIN"
    end
  end

  describe "::XPermittedCrossDomainPolicies" do
    it "is set to none" do
      add_handler Kemal::Shield::XPermittedCrossDomainPolicies.new
      request = HTTP::Request.new("GET", "/")
      
      client_response = call_request_on_app(request)
      client_response.headers.has_key?("X-Permitted-Cross-Domain-Policies").should be_true
      client_response.headers["X-Permitted-Cross-Domain-Policies"].should eq "none"
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
