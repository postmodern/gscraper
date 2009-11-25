require 'spec_helper'
require 'helpers/query'
require 'has_pages_examples'
require 'page_has_results_examples'
require 'search/page_has_results_examples'

require 'gscraper/search/ajax_query'

describe GScraper::Search::AJAXQuery do
  include Helpers

  before(:all) do
    @query = GScraper::Search::AJAXQuery.new(:query => Helpers::DEFAULT_QUERY)
    @page = @query.first_page
  end

  it_should_behave_like "has Pages"
  it_should_behave_like "Page has Results"
  it_should_behave_like "Page has Search Results"

  describe "Search URL" do
    before(:all) do
      @uri = @query.search_url
    end

    it "should be a valid HTTP URI" do
      @uri.class.should == URI::HTTP
    end

    it "should be a RESTful AJAX Search URL" do
      @uri.path.should == '/uds/GwebSearch'
    end

    it "should have the default 'callback' query-param" do
      callback = @uri.query_params['callback']
      callback.should == 'google.search.WebSearch.RawCompletion'
    end

    it "should have the default 'context' query-param" do
      @uri.query_params['context'].should == '0'
    end

    it "should have a default 'lstkp' query-param" do
      @uri.query_params['lstkp'].should == '0'
    end

    it "should have a default 'rsz' query-param of 'large'" do
      @uri.query_params['rsz'].should == 'large'
    end

    it "should have a default 'hl' query-param" do
      hl = @uri.query_params['hl']
      hl.should == GScraper::Search::AJAXQuery::DEFAULT_LANGUAGE
    end

    it "should have a default 'gss' query-param of '.com'" do
      @uri.query_params['gss'].should == '.com'
    end

    it "should have a 'q' query-param" do
      @uri.query_params['q'].should == Helpers::DEFAULT_QUERY
    end

    it "should have a default 'sig' query-param" do
      sig = @uri.query_params['sig']
      sig.should == GScraper::Search::AJAXQuery::DEFAULT_SIG
    end

    it "should have a default 'key' query-param" do
      key = @uri.query_params['key']
      key.should == GScraper::Search::AJAXQuery::DEFAULT_KEY
    end

    it "should have a default 'v' query-param" do
      v = @uri.query_params['v']
      v.should == GScraper::Search::AJAXQuery::DEFAULT_VERSION
    end
  end

  describe "page specific URLs" do
    before(:all) do
      @uri = @query.page_url(2)
    end

    it "should have a 'start' query-param" do
      @uri.query_params['start'].should == @query.results_per_page
    end
  end

  describe "queries from AJAX search URLs" do
    before(:all) do
      @version = '1.0'
      @language = 'en'
      @sig = '582c1116317355adf613a6a843f19ece'
      @key = 'notsupplied'
      @query = GScraper::Search::AJAXQuery.from_url("http://www.google.com/uds/GwebSearch?v=#{@version}&lstkp=0&rsz=large&hl=#{@language}&callback=google.search.WebSearch.RawCompletion&sig=#{@sig}&q=#{Helpers::DEFAULT_QUERY}&gss=.com&context=0&key=#{@key}")
    end

    it "should have a version" do
      @query.version.should == @version
    end

    it "should have a language" do
      @query.language.should == @language
    end

    it "should have a sig" do
      @query.sig.should == @sig
    end

    it "should have a key" do
      @query.key.should == @key
    end

    it "should have a query" do
      @query.query.should == Helpers::DEFAULT_QUERY
    end
  end
end
