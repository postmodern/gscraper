#
# GScraper - A web-scraping interface to various Google Services.
#
# Copyright (c) 2007-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'gscraper/search/web_query'
require 'gscraper/search/ajax_query'

module GScraper
  module Search
    #
    # Creates a new web-query.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @yield [query]
    #   If a block is given, it will be passed the new web-query.
    #
    # @yieldparam [WebQuery] query
    #   The new web query.
    #
    # @return [WebQuery]
    #   The new web-query.
    #
    # @example
    #   Search.query(:query => 'ruby', :with_words => 'sow rspec')
    #
    # @example
    #   Search.query(:exact_phrase => 'fluent interfaces') do |q|
    #     q.within_past_week = true
    #   end
    #
    # @see WebQuery#initialize
    #
    def Search.query(options={},&block)
      WebQuery.new(options,&block)
    end

    #
    # Creates a web-query from a search URL.
    #
    # @param [String] url
    #   The search URL.
    #
    # @yield [query]
    #   If a block is given, it will be passed the new web-query.
    #
    # @yieldparam [WebQuery] query
    #   The new web query.
    #
    # @return [WebQuery]
    #   The new web-query.
    #
    # @example
    #   Search.query_from_url('http://www.google.com/search?q=ruby+zen)
    #
    # @example
    #   Search.query_from_url('http://www.google.com/search?q=ruby') do |q|
    #     q.within_last_month = true
    #     q.occurs_within = :title
    #   end
    #
    # @see WebQuery.from_url.
    #
    def Search.query_from_url(url,&block)
      WebQuery.from_url(url,&block)
    end

    #
    # Creates a new AJAX query.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @yield [query]
    #   If a block is given, the new AJAX query will be passed to it.
    #
    # @yieldparam [AJAXQuery] query
    #   The new AJAX query.
    #
    # @example
    #   Search.ajax_query(:query => 'ruby')
    #
    # @see AJAXQuery#initialize
    #
    def Search.ajax_query(options={},&block)
      AJAXQuery.new(options,&block)
    end

    #
    # Creates a AJAX query from a given search URL.
    #
    # @param [URI::HTTP] url
    #   The search URL.
    #
    # @yield [query]
    #   If a block is given, the new AJAX query will be passed to it.
    #
    # @yieldparam [AJAXQuery] query
    #   The new AJAX query.
    #
    # @see AJAXQuery.from_url.
    #
    def Search.ajax_query_from_url(url,&block)
      AJAXQuery.from_url(url,&block)
    end
  end
end
