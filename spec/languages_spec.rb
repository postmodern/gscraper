require 'spec_helper'
require 'gscraper/languages'

describe GScraper::Languages do
  it "should lookup the language for a locale" do
    GScraper::Languages.find('es').should == 'es'
  end

  it "should lookup the language for locale_country" do
    GScraper::Languages.find('es_AR').should == 'es'
  end

  it "should lookup the language for a locale@alias" do
    GScraper::Languages.find('en@quot').should == 'en'
  end

  it "should map zh_CN* to zh-CN" do
    GScraper::Languages.find('zh_CN').should == 'zh-CN'
  end

  it "should map zh_TW* to zh-TW" do
    GScraper::Languages.find('zh_TW').should == 'zh-TW'
  end
end
