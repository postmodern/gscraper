require 'spec_helper'

shared_examples_for "has Sponsored Links" do
  it "should have ads" do
    @links.length.should_not == 0
  end

  it "should have titles" do
    @links.each_title do |title|
      title.should_not be_nil
    end
  end

  it "should have non-empty titles" do
    @links.each_title do |title|
      title.length.should_not == 0
    end
  end

  it "should have URLs" do
    @links.each_url do |url|
      url.should_not be_nil
    end
  end

  it "should have valid URLs" do
    @links.each_url do |url|
      uri_should_be_valid(url)
    end
  end

  it "should have direct URLs" do
    @links.each_direct_url do |url|
      url.should_not be_nil
    end
  end

  it "should have valid direct URLs" do
    @links.each_direct_url do |url|
      uri_should_be_valid(url)
    end
  end
end
