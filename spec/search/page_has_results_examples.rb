require 'spec_helper'

shared_examples_for "Page has Search Results" do

  it "should have incremental ranks" do
    ranks = @page.ranks

    (0..(ranks.length - 2)).each do |index|
      ranks[index].should < ranks[index + 1]
    end
  end

  it "should have titles" do
    @page.each_title do |title|
      title.should_not be_nil
    end
  end

  it "should have non-empty titles" do
    @page.each_title do |title|
      title.length.should_not == 0
    end
  end

  it "should have URLs" do
    @page.each_url do |url|
      url.should_not be_nil
    end
  end

  it "should have valid URLs" do
    @page.each_url do |url|
      uri_should_be_valid(url)
    end
  end

  it "should have atleast one cached URL" do
    @page.cached_urls.length.should_not == 0
  end

end
