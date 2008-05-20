#
#--
# GScraper - A web-scraping interface to various Google Services.
#
# Copyright (c) 2007-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#++
#

require 'gscraper/search/result'
require 'gscraper/search/page'
require 'gscraper/search/query'
require 'gscraper/extensions/uri'
require 'gscraper/has_pages'
require 'gscraper/gscraper'

require 'json'

module GScraper
  module Search
    class AJAXQuery < Query

      include HasPages

      RESULTS_PER_PAGE = 8

      # AJAX API host
      API_HOST = 'www.google.com'

      API_URL = "http://#{API_HOST}/uds/GwebSearch?callback=google.search.WebSearch.RawCompletion&context=0&lstkp=0&rsz=large"

      # The search language
      attr_accessor :language

      # The search signature
      attr_accessor :sig

      # The search key
      attr_accessor :key

      # The API version
      attr_accessor :version

      #
      # Creates a new AJAXQuery with the given _options_. If a _block_ is
      # given it will be passed the newly created AJAXQuery object.
      #
      # _options_ may contain the following keys:
      # <tt>:language</tt>:: The search language. Defaults to <tt>:en</tt>.
      # <tt>:sig</tt>:: The search signature. Defaults to
      #                 +582c1116317355adf613a6a843f19ece+.
      # <tt>:key</tt>:: The search key. Defaults to <tt>:notsupplied</tt>.
      # <tt>:version</tt>:: The desired API version. Defaults to
      #                     <tt>1.0</tt>.
      #
      def initialize(options={},&block)
        @agent = GScraper.web_agent(options)

        @language = (options[:language] || :en)

        @sig = (options[:sig] || '582c1116317355adf613a6a843f19ece')
        @key = (options[:key] || :notsupplied)
        @version = (options[:version] || '1.0')

        super(options,&block)
      end

      #
      # Creates a new AJAXQuery object from the specified URL. If a block is
      # given, it will be passed the newly created AJAXQuery object.
      #
      def self.from_url(url,options={},&block)
        url = URI(url.to_s)

        options[:language] = url.query_params['hl']
        options[:query] = url.query_params['q']

        options[:sig] = url.query_params['sig']
        options[:key] = url.query_params['key']
        options[:version] = url.query_params['v']

        return self.new(options,&block)
      end

      #
      # Returns +RESULTS_PER_PAGE+.
      #
      def results_per_page
        RESULTS_PER_PAGE
      end

      #
      # Returns the URL that represents the query.
      #
      def search_url
        search_url = URI(API_URL)

        search_url.query_params['hl'] = @language
        search_url.query_params['gss'] = '.com'
        search_url.query_params['q'] = expression
        search_url.query_params['sig'] = @sig
        search_url.query_params['key'] = @key
        search_url.query_params['v'] = @version

        return search_url
      end

      #
      # Returns the URL that represents the query of a specific
      # _page_index_.
      #
      def page_url(page_index)
        url = search_url

        if page_index > 1
          url.query_params['start'] = result_offset_of(page_index)
        end

        return url
      end

      #
      # Returns a Page object containing Result objects at the specified
      # _page_index_.
      #
      def page(page_index)
        Page.new do |new_page|
          body = @agent.get(page_url(page_index)).body
          hash = JSON.parse(body.scan(/\{.*\}/).first)

          rank_offset = result_offset_of(page_index)

          if (hash.kind_of?(Hash) && hash['results'])
            hash['results'].each_with_index do |result,index|
              rank = rank_offset + (index + 1)
              title = Hpricot(result['title']).inner_text
              url = result['unescapedUrl']
              summary = Hpricot(result['content']).inner_text
              cached_url = result['cacheUrl']

              new_page << Result.new(rank,title,url,summary,cached_url)
            end
          end
        end
      end

    end
  end
end
