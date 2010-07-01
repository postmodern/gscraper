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
      # Creates a new {Result} object.
      #
      # @param [Integer] rank
      #   The rank of the result.
      #
      # @param [String] title
      #   The title of the result.
      #
      # @param [String] summary
      #   The summary of the result.
      #
      # @param [URI::HTTP] cached_url
      #   The Cached URL for the result.
      #
      # @param [URI::HTTP] similar_url
      #   The Similar Query URL for the result.
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
      # @return [Mechanize::Page]
      #   The page the result represents.
      #
      def page
        @agent.get(@url)
      end

      #
      # Fetches the Cached Page of the result.
      #
      # @return [Mechanize::Page]
      #   The Cached Page for the result.
      #
      def cached_page
        if @cached_url
          return @agent.get(@cached_url)
        end
      end

      #
      # The result's title.
      #
      # @return [String]
      #   The title of the result.
      #
      def to_s
        @title.to_s
      end

    end
  end
end
