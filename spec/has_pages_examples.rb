require 'pathname'
require Pathname(__FILE__).dirname.join('spec_helper').expand_path

require 'gscraper/has_pages'

shared_examples_for "has Pages" do

  it "should have a first page" do
    @query.first_page.should_not be_nil
  end

  it "should allow indexed access" do
    @query[1].should_not be_nil
  end

  it "should allow accessing multiple pages" do
    pages = @query.pages(1..2)
    pages.should_not be_nil
    pages.length.should == 2
  end

end
