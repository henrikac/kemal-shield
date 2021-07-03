require "./spec_helper"

describe "Kemal::Shield" do
  describe "Config" do
    describe "INSTANCE" do
      it "returns a Kemal::Shield::Config object" do
        typeof(Kemal::Shield::Config::INSTANCE).should eq Kemal::Shield::Config
      end
    end

    describe "#coop" do
      after_each do
        Kemal::Shield.config.coop = "same-origin"
      end

      it "sets the policy correctly" do
        Kemal::Shield.config.coop = "unsafe-none"
        Kemal::Shield.config.coop.should eq "unsafe-none"
      end

      it "raise an ArgumentError if invalid policy" do
        expect_raises(ArgumentError) do
          Kemal::Shield.config.coop = "invalid-policy"
        end
      end
    end

    describe "#corp" do
      after_each do
        Kemal::Shield.config.corp = "same-origin"
      end

      it "sets the policy correctly" do
        Kemal::Shield.config.corp = "same-site"
        Kemal::Shield.config.corp.should eq "same-site"
      end

      it "raise an ArgumentError if invalid policy" do
        expect_raises(ArgumentError) do
          Kemal::Shield.config.corp = "invalid-policy"
        end
      end
    end

    describe "#referrer_policy" do
      after_each do
        Kemal::Shield.config.referrer_policy = ["no-referrer"]
      end

      it "should set the value correctly" do
        tests = [
          {tokens: ["origin", "strict-origin", "same-origin"], expected: "origin,strict-origin,same-origin"},
          {tokens: ["no-referrer"], expected: "no-referrer"},
          {tokens: ["no-referrer", "no-referrer-when-downgrade"], expected: "no-referrer,no-referrer-when-downgrade"}
        ]

        tests.each do |test|
          Kemal::Shield.config.referrer_policy = test[:tokens]
          Kemal::Shield.config.referrer_policy.should eq test[:expected]
        end
      end

      it "raises an ArgumentError if tokens are empty" do
        expect_raises(ArgumentError) do
          Kemal::Shield.config.referrer_policy = [] of String
        end
      end

      it "raises an ArgumentError if tokens contains invalid tokens" do
        expect_raises(ArgumentError) do
          Kemal::Shield.config.referrer_policy = ["invalid-token"]
        end
      end

      it "raises an ArgumentError if tokens contains dublicates" do
        expect_raises(ArgumentError) do
          Kemal::Shield.config.referrer_policy = ["no-referrer", "no-referrer"]
        end
      end
    end

    describe "#x_frame_options" do
      after_each do
        Kemal::Shield.config.x_frame_options = "SAMEORIGIN"
      end

      it "should set the value correctly" do
        tests = [
          {input: "SAME-ORIGIN", expected: "SAMEORIGIN"},
          {input: "DENY", expected: "DENY"},
          {input: "saMe-ORIgiN", expected: "SAMEORIGIN"}
        ]

        tests.each do |test|
          Kemal::Shield.config.x_frame_options = test[:input]
          Kemal::Shield.config.x_frame_options.should eq test[:expected]
        end
      end

      it "should raise an ArgumentError if invalid option" do
        expect_raises(ArgumentError) do
          Kemal::Shield.config.x_frame_options = "INVALID"
        end
      end

      it "should raise an ArgumentError if option is set to ALLOW-FROM" do
        expect_raises(ArgumentError) do
          Kemal::Shield.config.x_frame_options = "ALLOW-FROM"
        end
      end
    end

    describe "#x_permitted_cross_domain_policies" do
      after_each do
        Kemal::Shield.config.x_permitted_cross_domain_policies = "none"
      end

      it "should set the value correctly" do
        policies = ["none", "master-only", "by-content-type", "all"]

        policies.each do |policy|
          Kemal::Shield.config.x_permitted_cross_domain_policies = policy
          Kemal::Shield.config.x_permitted_cross_domain_policies.should eq policy
        end
      end

      it "should raise an ArgumentError if invalid policy" do
        expect_raises(ArgumentError) do
          Kemal::Shield.config.x_permitted_cross_domain_policies = "invalid"
        end
      end
    end
  end

  describe ".config" do
    it "returns Kemal::Shield::Config::INSTANCE" do
      Kemal::Shield.config.should be Kemal::Shield::Config::INSTANCE
    end

    it "yields Kemal::Shield::Config::INSTANCE" do
      Kemal::Shield.config do |config|
        config.should be Kemal::Shield::Config::INSTANCE
      end
    end
  end
end
