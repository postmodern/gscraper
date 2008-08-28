require 'spec_helper'

require 'gscraper/gscraper'

describe "GScraper" do
  describe "User-Agent support" do
    it "should have a default User-Agent string" do
      GScraper.user_agent.should_not be_nil
    end
  end

  describe "Proxy support" do
    it "should provide a :host key" do
      GScraper.proxy.has_key?(:host).should == true
    end

    it "should provide a :port key" do
      GScraper.proxy.has_key?(:port).should == true
    end

    it "should provide a :user key" do
      GScraper.proxy.has_key?(:user).should == true
    end

    it "should provide a :password key" do
      GScraper.proxy.has_key?(:password).should == true
    end
  end
end
