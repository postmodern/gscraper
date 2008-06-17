require 'pathname'
require Pathname(__FILE__).dirname.join('..','..','spec_helper').expand_path

require 'gscraper/extensions/uri'

describe URI::HTTP do
  it "should include QueryParams" do
    URI::HTTP.include?(URI::QueryParams).should == true
  end
end
