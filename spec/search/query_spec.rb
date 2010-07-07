require 'spec_helper'

require 'gscraper/search/query'

describe GScraper::Search::Query do
  it "should have a default host of www.google.com" do
    query = GScraper::Search::Query.new

    query.search_host.should == 'www.google.com'
  end

  it "should allow using alternate hosts" do
    alternate_host = 'www.google.com.ar'
    query = GScraper::Search::Query.new(
      :search_host => alternate_host
    )

    query.search_host.should == alternate_host
  end

  it "should have a default language" do
    query = GScraper::Search::Query.new

    query.language.should_not be_nil
  end

  it "should support basic queries" do
    expr = 'ruby -blog'
    query = GScraper::Search::Query.new(:query => expr)
    query.expression.should == expr
  end

  it "should support the 'link' modifier" do
    url = 'www.wired.com/'
    query = GScraper::Search::Query.new(:link => url)
    query.expression.should == "link:#{url}"
  end

  it "should support the 'related' modifier" do
    url = 'www.rubyinside.com'
    query = GScraper::Search::Query.new(:related => url)
    query.expression.should == "related:#{url}"
  end

  it "should support the 'info' modifier" do
    url = "www.rspec.info"
    query = GScraper::Search::Query.new(:info => url)
    query.expression.should == "info:#{url}"
  end

  it "should support the 'site' modifier" do
    url = "www.ruby-lang.net"
    query = GScraper::Search::Query.new(:site => url)
    query.expression.should == "site:#{url}"
  end

  it "should support the 'filetype' modifier" do
    file_type = 'rss'
    query = GScraper::Search::Query.new(:filetype => file_type)
    query.expression.should == "filetype:#{file_type}"
  end

  it "should support 'allintitle' options" do
    words = ['one', 'two', 'three']
    query = GScraper::Search::Query.new(:allintitle => words)
    query.expression.should == "allintitle:#{words.join(' ')}"
  end

  it "should support the 'intitle' modifier" do
    word = 'coffee'
    query = GScraper::Search::Query.new(:intitle => word)
    query.expression.should == "intitle:#{word}"
  end

  it "should support 'allinurl' options" do
    params = ['search', 'id', 'page']
    query = GScraper::Search::Query.new(:allinurl => params)
    query.expression.should == "allinurl:#{params.join(' ')}"
  end

  it "should support the 'inurl' modifier" do
    param = 'id'
    query = GScraper::Search::Query.new(:inurl => param)
    query.expression.should == "inurl:#{param}"
  end

  it "should support 'allintext' options" do
    words = ['dog', 'blog', 'log']
    query = GScraper::Search::Query.new(:allintext => words)
    query.expression.should == "allintext:#{words.join(' ')}"
  end

  it "should support the 'intext' modifier" do
    word = 'word'
    query = GScraper::Search::Query.new(:intext => word)
    query.expression.should == "intext:#{word}"
  end

  it "should support 'exact phrases'" do
    phrase = 'how do you do?'
    query = GScraper::Search::Query.new(:exact_phrase => phrase)
    query.expression.should == "\"#{phrase}\""
  end

  it "should support 'with words'" do
    words = ['one', 'two', 'three']
    query = GScraper::Search::Query.new(:with_words => words)
    query.expression.should == words.join(' OR ')
  end

  it "should support 'without words'" do
    words = ['bla', 'haha', 'spam']
    query = GScraper::Search::Query.new(:without_words => words)
    query.expression.should == words.map { |word| "-#{word}" }.join(' ')
  end

  it "should support 'numeric range'" do
    range = (3..8)
    query = GScraper::Search::Query.new(:numeric_range => range)
    query.expression.should == "#{range.begin}..#{range.end}"
  end

end
