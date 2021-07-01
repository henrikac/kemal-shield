require "./spec_helper"

describe "Kemal::Shield" do
  before_each do
    get "/" do
      "GET"
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

    it "raises an ArgumentError if max_age if less than 0" do
      expect_raises(ArgumentError) do
        Kemal::Shield::ExpectCT.new(-1)
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

    it "raises an ArgumentError if max_age is less than 0" do
      expect_raises(ArgumentError) do
        Kemal::Shield::StrictTransportSecurity.new(-1)
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
      Kemal::Shield.config.x_dns_prefetch_control_on = false
    end

    it "is set to off by default" do
      add_handler Kemal::Shield::XDNSPrefetchControl.new
      request = HTTP::Request.new("GET", "/")

      client_response = call_request_on_app(request)
      client_response.headers.has_key?("X-DNS-Prefetch-Control").should be_true
      client_response.headers["X-DNS-Prefetch-Control"].should eq "off"
    end

    it "can be set to on" do
      Kemal::Shield.config.x_dns_prefetch_control_on = true
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
