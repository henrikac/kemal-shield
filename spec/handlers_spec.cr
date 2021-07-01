require "./spec_helper"

describe "Kemal::Shield" do
  before_each do
    get "/" do
      "GET"
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
