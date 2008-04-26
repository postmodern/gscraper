GScraper
    by Postmodern Modulus III
    http://rubyforge.net/projects/gscraper/

== DESCRIPTION:
  
GScraper is a web-scraping interface to various Google Services.

== FEATURES/PROBLEMS:
  
* Supports the Google Search service.
  * Provides access to search results and ranks.
  * Provides access to the Sponsored Links.
* Provides HTTP access with custom User-Agent strings.
* Provides proxy settings for HTTP access.

== REQUIREMENTS:

* Hpricot
* WWW::Mechanize

== INSTALL:

  $ sudo gem install gscraper

== EXAMPLES:

* Basic query:

    q = GScraper::Search.query(:query => 'ruby')

* Advanced query:

    q = GScraper::Search.query(:query => 'ruby') do |q|
      q.without_words = 'is'
      q.within_past_day = true
      q.numeric_range = 2..10
    end

* Queries from URLs:

    q = GScraper::Search.query_from_url('http://www.google.com/search?as_q=ruby&as_epq=&as_oq=rails&as_ft=i&as_qdr=all&as_occt=body&as_rights=%28cc_publicdomain%7Ccc_attribute%7Ccc_sharealike%7Ccc_noncommercial%29.-%28cc_nonderived%29')

    q.query # =>; "ruby"
    q.with_words # => "rails"
    q.occurrs_within # => :title
    q.rights # => :cc_by_nc

* Getting the search results:

    q.first_page.select do |result|
      result.title =~ /Blog/
    end

    q.page(2).map do |result|
      result.title.reverse
    end

    q.result_at(25) # => Result

    q.top_result # => Result

* A Result object contains the rank, title, summary, cahced URL, similiar
  query URL and link URL of the search result.

    page = q.page(2)

    page.urls # => [...]
    page.summaries # => [...]
    page.ranks_of { |result| result.url =~ /^https/ } # => [...]
    page.titles_of { |result| result.summary =~ /password/ } # => [...]
    page.cached_pages # => [...]
    page.similar_queries # => [...]

* Iterating over the search results:

    q.each_on_page(2) do |result|
      puts result.title
    end

    page.each do |result|
      puts result.url
    end

* Iterating over the data within the search results:

    page.each_title do |title|
      puts title
    end

    page.each_summary do |text|
      puts text
    end

* Selecting search results:

    page.results_with do |result|
      ((result.rank > 2) && (result.rank < 10))
    end

    page.results_with_title(/Ruby/i) # => [...]

* Selecting data within the search results:

    page.titles # => [...]

    page.summaries # => [...]

* Selecting the data of search results based on the search result:

    page.urls_of do |result|
      result.description.length > 10
    end

* Selecting the Sponsored Links of a Query:

    q.sponsored_links # => [...]

    q.top_sponsored_link # => SponsoredAd

* Setting the User-Agent globally:

    GScraper.user_agent # => nil
    GScraper.user_agent = 'Awesome Browser v1.2'

== LICENSE:

The MIT License

Copyright (c) 2007-2008 Hal Brodigan

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
