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

require 'gscraper/search/query'
require 'gscraper/gscraper'

module GScraper
  module Search
    class Result

      # Rank of the result page
      attr_reader :rank

      # Title of the result page
      attr_reader :title

      # URL of the result page
      attr_reader :url

      # Summary from the result page
      attr_reader :summary

      # URL of the cached result page
      attr_reader :cached_url

      # URL of the similar results Query
      attr_reader :similar_url

      #
      # Creates a new Result object with the given _rank_, _title_
      # _summary_, _url_, _size_, _cache_url_ and _similar_url_.
      #
      def initialize(rank,title,url,summary,cached_url=nil,similar_url=nil)
        @agent = GScraper.web_agent

        @rank = rank
        @title = title
        @url = url
        @summary = summary
        @cached_url = cached_url
        @similar_url = similar_url
      end

      #
      # Fetches the page of the result.
      #
      def page
        @agent.get(@url)
      end

      #
      # Fetches the cached page of the result.
      #
      def cached_page
        if @cached_url
          return @agent.get(@cached_url)
        end
      end

      #
      # Returns a string containing the result's title.
      #
      def to_s
        @title.to_s
      end

    end
  end
end
