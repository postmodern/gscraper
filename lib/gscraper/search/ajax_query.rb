#
# GScraper - A web-scraping interface to various Google Services.
#
# Copyright (c) 2007-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#

require 'gscraper/search/result'
require 'gscraper/search/page'
require 'gscraper/search/query'
require 'gscraper/extensions/uri'
require 'gscraper/has_pages'
require 'gscraper/gscraper'

require 'json'
require 'nokogiri'

module GScraper
  module Search
    #
    # Represents a Query through the Google AJAX search API.
    #
    class AJAXQuery < Query

      include HasPages

      # Maximum results per-page
      RESULTS_PER_PAGE = 8

      # AJAX API Path
      PATH = '/uds/GwebSearch'

      # AJAX API Query string
      QUERY = 'callback=google.search.WebSearch.RawCompletion&context=0&lstkp=0&rsz=large'

      # Default signature
      DEFAULT_SIG = '582c1116317355adf613a6a843f19ece'

      # Default key
      DEFAULT_KEY = 'notsupplied'

      # Default version
      DEFAULT_VERSION = '1.0'

      # The search signature
      attr_accessor :sig

      # The search key
      attr_accessor :key

      # The API version
      attr_accessor :version

      #
      # Creates a new AJAX query.
      #
      # @param [Hash] options
      #   Query options.
      #
      # @option options [String] :search_host (www.google.com)
      #   The host to submit queries to.
      #
      # @option options [String, Symbol] :language (Languages.native)
      #   The search language.
      #
      # @option options [String] :sig ('582c1116317355adf613a6a843f19ece')
      #   The search signature.
      #
      # @option options [String, Symbol] :key ('notsupplied')
      #   The search key.
      #
      # @option options [Float] :version (1.0)
      #   The desired API version.
      #
      # @yield [query]
      #   If a block is given, the new AJAX query will be passed to it.
      #
      # @yieldparam [AJAXQuery] query
      #   The new AJAX query.
      #
      def initialize(options={},&block)
        @agent = GScraper.web_agent(options)

        @sig = (options[:sig] || DEFAULT_SIG)
        @key = (options[:key] || DEFAULT_KEY)
        @version = (options[:version] || DEFAULT_VERSION)

        super(options,&block)
      end

      #
      # Creates a new AJAX query from the specified URL.
      #
      # @param [URI::HTTP, String] url
      #   The URL to create the query from.
      #
      # @param [Hash] options
      #   Additional query options.
      #
      # @yield [query]
      #   If a block is given, it will be passed the new AJAX query.
      #
      # @yieldparam [AJAXQuery] query
      #   The new AJAX query.
      #
      # @return [AJAXQuery]
      #   The new AJAX query.
      #
      # @see AJAXQuery.new
      #
      def AJAXQuery.from_url(url,options={},&block)
        url = URI(url.to_s)

        options[:language] = url.query_params['hl']
        options[:query] = url.query_params['q']

        options[:sig] = url.query_params['sig']
        options[:key] = url.query_params['key']
        options[:version] = url.query_params['v']

        return AJAXQuery.new(options,&block)
      end

      #
      # The results per page.
      #
      # @return [Integer]
      #   The number of results per page.
      #
      # @see RESULTS_PER_PAGE
      #
      def results_per_page
        RESULTS_PER_PAGE
      end

      #
      # The URL that represents the query.
      #
      # @return [URI::HTTP]
      #   The URL for the query.
      #
      def search_url
        search_url = URI::HTTP.build(
          :host => search_host,
          :path => PATH,
          :query => QUERY
        )

        search_url.query_params['hl'] = @language
        search_url.query_params['gss'] = '.com'
        search_url.query_params['q'] = expression
        search_url.query_params['sig'] = @sig
        search_url.query_params['key'] = @key
        search_url.query_params['v'] = @version

        return search_url
      end

      #
      # The URL that represents the query at a specific page index.
      #
      # @param [Integer] page_index
      #   The page index to create the URL for.
      #
      # @return [URI::HTTP]
      #   The query URL for the given page index.
      #
      def page_url(page_index)
        url = search_url

        if page_index > 1
          url.query_params['start'] = result_offset_of(page_index)
        end

        return url
      end

      #
      # A page containing results at the specified page index.
      #
      # @param [Integer] page_index
      #   The index of the page.
      #
      # @return [Page<Result>]
      #   A page object.
      #
      def page(page_index)
        Page.new do |new_page|
          body = @agent.get(page_url(page_index)).body
          hash = JSON.parse(body.scan(/\{.*\}/).first)

          rank_offset = result_offset_of(page_index)

          if (hash.kind_of?(Hash) && hash['results'])
            hash['results'].each_with_index do |result,index|
              rank = rank_offset + (index + 1)
              title = Nokogiri::HTML(result['title']).inner_text
              url = URI(URI.escape(result['unescapedUrl']))

              unless result['content'].empty?
                summary = Nokogiri::HTML(result['content']).inner_text
              else
                summary = ''
              end

              cached_url = URI(result['cacheUrl'])

              new_page << Result.new(rank,title,url,summary,cached_url)
            end
          end
        end
      end

    end
  end
end
