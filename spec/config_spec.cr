require "./spec_helper"

describe "Kemal::Shield" do
  describe "Config" do
    describe "INSTANCE" do
      it "returns a Kemal::Shield::Config object" do
        typeof(Kemal::Shield::Config::INSTANCE).should eq Kemal::Shield::Config
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
