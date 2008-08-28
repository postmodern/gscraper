require 'spec_helper'

shared_examples_for "Page has Results" do

  it "should have results" do
    @page.length.should_not == 0
  end

  it "should have the maximum amount of results per page" do
    @page.length.should == @query.results_per_page
  end

end
