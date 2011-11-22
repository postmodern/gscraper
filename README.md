# GScraper

* [github.com/postmodern/gscraper](http://github.com/postmodern/gscraper/)
* [github.com/postmodern/gscraper/issues](http://github.com/postmodern/gscraper/issues)
* Postmodern (postmodern.mod3 at gmail.com)

## Description
  
GScraper is a web-scraping interface to various Google Services.

## Features
  
* Supports the Google Search service.
  * Provides access to search results and ranks.
  * Provides access to the Sponsored Links.
* Provides HTTP access with custom User-Agent strings.
* Provides proxy settings for HTTP access.

## Requirements

* [json](http://flori.github.com/json/) ~> 1.6
* [uri-query_params](http://github.com/postmodern/uri-query_params#readme) ~> 0.5
* [mechanize](http://mechanize.rubyforge.org/mechanize/) ~> 1.0.0

## Install

    $ sudo gem install gscraper

## Examples

Basic query:

    q = GScraper::Search.query(:query => 'ruby')

Advanced query:

    q = GScraper::Search.query(:query => 'ruby') do |q|
      q.without_words = 'is'
      q.within_past_day = true
      q.numeric_range = 2..10
    end

Queries from URLs:

    q = GScraper::Search.query_from_url('http://www.google.com/search?as_q=ruby&as_epq=&as_oq=rails&as_ft=i&as_qdr=all&as_occt=body&as_rights=%28cc_publicdomain%7Ccc_attribute%7Ccc_sharealike%7Ccc_noncommercial%29.-%28cc_nonderived%29')

    q.query # => "ruby"
    q.with_words # => "rails"
    q.occurs_within # => :title
    q.rights # => :cc_by_nc

Getting the search results:

    q.first_page.select do |result|
      result.title =~ /Blog/
    end

    q.page(2).map do |result|
      result.title.reverse
    end

    q.result_at(25) # => Result

    q.top_result # => Result

A Result object contains the rank, title, summary, cahced URL, similiar
query URL and link URL of the search result.

    page = q.page(2)

    page.urls # => [...]
    page.summaries # => [...]
    page.ranks_of { |result| result.url =~ /^https/ } # => [...]
    page.titles_of { |result| result.summary =~ /password/ } # => [...]
    page.cached_pages # => [...]
    page.similar_queries # => [...]

Iterating over the search results:

    q.each_on_page(2) do |result|
      puts result.title
    end

    page.each do |result|
      puts result.url
    end

Iterating over the data within the search results:

    page.each_title do |title|
      puts title
    end

    page.each_summary do |text|
      puts text
    end

Selecting search results:

    page.results_with do |result|
      ((result.rank > 2) && (result.rank < 10))
    end

    page.results_with_title(/Ruby/i) # => [...]

Selecting data within the search results:

    page.titles # => [...]

    page.summaries # => [...]

Selecting the data of search results based on the search result:

    page.urls_of do |result|
      result.description.length > 10
    end

Selecting the Sponsored Links of a Query:

    q.sponsored_links # => [...]

    q.top_sponsored_link # => SponsoredAd

Setting the User-Agent globally:

    GScraper.user_agent # => nil
    GScraper.user_agent = 'Awesome Browser v1.2'

## License

GScraper - A web-scraping interface to various Google Services.

Copyright (c) 2007-2010 Hal Brodigan (postmodern.mod3 at gmail.com)

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

