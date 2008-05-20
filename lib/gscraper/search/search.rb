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

require 'gscraper/search/web_query'
require 'gscraper/search/ajax_query'

module GScraper
  module Search
    #
    # Returns a new Query object with the given _options_. See Query.new.
    #
    #   Search.query(:query => 'ruby', :with_words => 'sow rspec')
    #
    #   Search.query(:exact_phrase => 'fluent interfaces') do |q|
    #     q.within_past_week = true
    #   end
    #
    def Search.query(options={},&block)
      WebQuery.new(options,&block)
    end

    #
    # Returns the Query object that represents the specified _url_.
    # See Query.from_url.
    #
    #   Search.query_from_url('http://www.google.com/search?q=ruby+zen)
    #
    #   Search.query_from_url('http://www.google.com/search?q=ruby') do |q|
    #     q.within_last_month = true
    #     q.occurrs_within = :title
    #   end
    #
    def Search.query_from_url(url,&block)
      WebQuery.from_url(url,&block)
    end

    #
    # Returns a new AJAXQuery object with the given _options_. See
    # AJAXQuery.new.
    #
    #   Search.ajax_query(:query => 'ruby')
    #
    def Search.ajax_query(options={},&block)
      AJAXQuery.new(options,&block)
    end

    #
    # Returns the AJAXQuery object that represents the specified _url_.
    # See AJAXQuery.from_url.
    #
    def Search.ajax_query_from_url(url,&block)
      AJAXQuery.from_url(url,&block)
    end
  end
end
