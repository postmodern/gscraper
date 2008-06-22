require 'spec_helper'

require 'gscraper/extensions/uri'

describe URI::HTTP do
  it "should include QueryParams" do
    URI::HTTP.include?(URI::QueryParams).should == true
  end
end
