require "./spec_helper"

describe "Kemal::Shield" do
  after_each do
    Kemal::Shield::HANDLERS.clear
  end

  describe "add_handler" do
    it "adds handler" do
      handler = Kemal::Shield::XPoweredBy.new

      Kemal::Shield.add_handler handler

      Kemal::Shield::HANDLERS.size.should eq 1
      Kemal::Shield::HANDLERS[0].should eq handler.class
    end

    it "raises DublicateHandlerError if a dublicate handler is added" do
      handler = Kemal::Shield::XPoweredBy.new
      Kemal::Shield.add_handler handler

      expect_raises(Kemal::Shield::DublicateHandlerError) do
        Kemal::Shield.add_handler Kemal::Shield::XPoweredBy.new
      end
    end
  end

  describe "remove_handler" do
    it "removes the given handler" do
      Kemal::Shield.activate

      build_main_handler

      expected = Kemal::Shield::ExpectCT
      actual = Kemal::Shield.remove_handler(Kemal::Shield::ExpectCT)

      Kemal::Shield::HANDLERS.size.should eq 14 # .activate adds 15 handlers
      actual.class.should eq expected
    end

    it "also removes handler from Kemal.config.handlers" do
      Kemal::Shield.activate

      build_main_handler

      handler_size = Kemal.config.handlers.size

      Kemal::Shield.remove_handler(Kemal::Shield::ExpectCT)

      Kemal.config.handlers.size.should eq handler_size - 1
      Kemal.config.handlers.each do |handler|
        handler.class.should_not eq Kemal::Shield::ExpectCT
      end
    end

    it "returns nil if the given handler is not in Shield::HANDLERS" do
      Kemal::Shield.activate
      Kemal::Shield.remove_handler(Kemal::Shield::ExpectCT)

      Kemal::Shield.remove_handler(Kemal::Shield::ExpectCT).should be_nil
    end
  end

  describe "deactivate" do
    it "removes all handlers added by Kemal::Shield.add_handler" do
      Kemal::Shield.activate
      Kemal::Shield::HANDLERS.size.should eq 15

      Kemal::Shield.deactivate
      Kemal::Shield::HANDLERS.empty?.should be_true
    end
  end

  describe "activate" do
    it "adds default handlers" do
      expected = [
        Kemal::Shield::ContentSecurityPolicy,
        Kemal::Shield::CrossOriginEmbedderPolicy,
        Kemal::Shield::CrossOriginOpenerPolicy,
        Kemal::Shield::CrossOriginResourcePolicy,
        Kemal::Shield::ExpectCT,
        Kemal::Shield::OriginAgentCluster,
        Kemal::Shield::ReferrerPolicy,
        Kemal::Shield::StrictTransportSecurity,
        Kemal::Shield::XContentTypeOptions,
        Kemal::Shield::XDNSPrefetchControl,
        Kemal::Shield::XDownloadOptions,
        Kemal::Shield::XFrameOptions,
        Kemal::Shield::XPermittedCrossDomainPolicies,
        Kemal::Shield::XPoweredBy,
        Kemal::Shield::XXSSProtection
      ]

      Kemal::Shield.activate

      Kemal::Shield::HANDLERS.each_with_index do |handler, i|
        handler.should eq expected[i]
      end
    end
  end
end







