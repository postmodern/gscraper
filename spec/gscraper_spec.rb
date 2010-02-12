require 'spec_helper'

require 'gscraper/gscraper'
require 'gscraper/version'

describe "GScraper" do
  it "should have a VERSION constant" do
    GScraper.should be_const_defined('VERSION')
  end

  describe "User-Agent support" do
    it "should have a default User-Agent string" do
      GScraper.user_agent.should_not be_nil
    end
  end

  describe "Proxy support" do
    it "should provide a :host key" do
      GScraper.proxy.should have_key(:host)
    end

    it "should provide a :port key" do
      GScraper.proxy.should have_key(:port)
    end

    it "should provide a :user key" do
      GScraper.proxy.should have_key(:user)
    end

    it "should provide a :password key" do
      GScraper.proxy.should have_key(:password)
    end
  end
end
