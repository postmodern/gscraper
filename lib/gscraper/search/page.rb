#
# GScraper - A web-scraping interface to various Google Services.
#
# Copyright (c) 2007-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'gscraper/page'

module GScraper
  module Search
    class Page < GScraper::Page

      alias results_with select

      #
      # Selects the results with the matching title.
      #
      # @param [String, Regexp] title
      #   The title to search for.
      #
      # @yield [result]
      #   The given block will be passed each matching result.
      #
      # @yieldparam [Result] result
      #   A result with the matching title.
      #
      # @return [Array<Result>]
      #   The results with the matching title.
      #
      # @example
      #   page.results_with_title('hackety org') #=> Page
      #
      # @example
      #   page.results_with_title(/awesome/) do |result|
      #     puts result.url
      #   end
      #
      def results_with_title(title)
        unless block_given?
          enum_for(:results_with_title,title)
        else
          results_with do |result|
            if result.title.match(title)
              yield result

              true
            end
          end
        end
      end

      #
      # Selects the results with the matching URL.
      #
      # @param [String, Regexp] url
      #   The URL to search for.
      #
      # @yield [result]
      #   The given block will be passed each matching result.
      #
      # @yieldparam [Result] result
      #   A result with the matching URL.
      #
      # @return [Array<Result>]
      #   The results with the matching URL.
      #
      # @example
      #   page.results_with_url(/\.com/) # => Page
      #
      # @example
      #   page.results_with_url(/^https:\/\//) do |result|
      #     puts result.title
      #   end
      #
      def results_with_url(url)
        unless block_given?
          enum_for(:results_with_url,url)
        else
          results_with do |result|
            if result.url.match(url)
              yield result

              true
            end
          end
        end
      end

      #
      # Selects the results with the matching summary.
      #
      # @param [String, Regexp] summary
      #   The summary to search for.
      #
      # @yield [result]
      #   The given block will be passed each matching result.
      #
      # @yieldparam [Result] result
      #   A result with the matching summary.
      #
      # @return [Array<Result>]
      #   The results with the matching summary.
      #
      # @example
      #   page.results_with_summary(/cheese cake/) # => Page
      #
      # @example
      #   page.results_with_summary(/Scientifically/) do |result|
      #     puts result.url
      #   end
      #
      def results_with_summary(summary)
        unless block_given?
          enum_for(:results_with_summary,summary)
        else
          results_with do |result|
            if result.summary.match(summary)
              yield result

              true
            end
          end
        end
      end

      #
      # Iterates over each result's rank within the page.
      #
      # @yield [rank]
      #   The given block will be passed the ranks of each result in
      #   the page.
      #
      # @yieldparam [Integer] rank
      #   The rank of a result in the page.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @example
      #   each_rank { |rank| puts rank }
      #
      def each_rank
        unless block_given?
          enum_for(:each_rank)
        else
          each { |result| yield result.rank }
        end
      end

      #
      # Iterates over each result's title within the page.
      #
      # @yield [title]
      #   The given block will be passed the title of each result in
      #   the page.
      #  
      # @yieldparam [String] title
      #   The title of a result in the page.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @example
      #   each_title { |title| puts title }
      #
      def each_title
        unless block_given?
          enum_for(:each_title)
        else
          each { |result| yield result.title }
        end
      end

      #
      # Iterates over each result's url within the page.
      #
      # @yield [url]
      #   The given block will be passed the URL of each result in
      #   the page.
      #  
      # @yieldparam [URI::HTTP] url
      #   The URL of a result in the page.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @example
      #   each_url { |url| puts url }
      #
      def each_url
        unless block_given?
          enum_for(:each_url)
        else
          each { |result| yield result.url }
        end
      end

      #
      # Iterates over each result's summary within the page.
      #
      # @yield [summary]
      #   The given block will be passed the summary of each result in
      #   the page.
      #  
      # @yieldparam [String] summary
      #   The summary of a result in the page.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @example
      #   each_summary { |summary| puts summary }
      #
      def each_summary
        unless block_given?
          enum_for(:each_summary)
        else
          each { |result| yield result.summary }
        end
      end

      #
      # Iterates over each result's cached URLs within the page.
      #
      # @yield [cached_url]
      #   The given block will be passed the Cached URL of each result in
      #   the page.
      #  
      # @yieldparam [URI::HTTP] cached_url
      #   The Cached URL of a result in the page.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @example
      #   each_cached_url { |cached_url| puts cached_url }
      #
      def each_cached_url
        unless block_given?
          enum_for(:each_cached_url)
        else
          each do |result|
            yield result.cached_url if result.cached_url
          end
        end
      end

      #
      # Iterates over each result's cached pages within the page.
      #
      # @yield [cached_page]
      #   The given block will be passed the Cached Page of each result in
      #   the page.
      #  
      # @yieldparam [Mechanize::Page] cached_page
      #   The Cached Page of a result in the page.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @example
      #   each_cached_page { |page| puts page.readlines }
      #
      def each_cached_page
        unless block_given?
          enum_for(:each_cached_page)
        else
          each do |result|
            yield result.cached_page if result.cached_page
          end
        end
      end

      #
      # Iterates over each result's similar Query URLs within the page.
      #
      # @yield [similar_url]
      #   The given block will be passed the Similar Query URL of each
      #   result in the page.
      #  
      # @yieldparam [URI::HTTP] similar_url
      #   The Cached URL of a result in the page.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      # @example
      #   each_similar_url { |similar_url| puts similar_url }
      #
      def each_similar_url
        unless block_given?
          enum_for(:each_similar_url)
        else
          each do |result|
            yield result.similar_url if result.similar_url
          end
        end
      end

      #
      # Returns the ranks of the results in the page.
      #
      # @return [Array<Integer>]
      #   The ranks of the results.
      #
      def ranks
        each_rank.to_a
      end

      #
      # Returns the titles of the results in the page.
      #
      # @return [Array<String>]
      #   The titles of the results.
      #
      def titles
        each_title.to_a
      end

      #
      # Returns the URLs of the results in the page.
      #
      # @return [Array<URI::HTTP>]
      #   The URLs of the results.
      #
      def urls
        each_url.to_a
      end

      #
      # Returns the summaries of the results in the page.
      #
      # @return [Array<String>]
      #   The summaries of the results.
      #
      def summaries
        each_summary.to_a
      end

      #
      # Returns the Cached URLs of the results in the page.
      #
      # @return [Array<URI::HTTP>]
      #   The Cached URLs of the results.
      #
      def cached_urls
        each_cached_url.to_a
      end

      #
      # Returns the Cached Pages of the results in the page.
      #
      # @return [Array<Mechanize::Page>]
      #   The Cached Pages of the results.
      #
      def cached_pages
        each_cached_page.to_a
      end

      #
      # Returns the Similar Query URLs of the results in the page.
      #
      # @return [Array<URI::HTTP>]
      #   The Similar Query URLs of the results.
      #
      def similar_urls
        each_similar_url.to_a
      end

      #
      # Returns the ranks of the results that match the given block.
      #
      # @yield [result]
      #   The given block will be used to filter the results in the page.
      #
      # @yieldparam [Result] result
      #   A result in the page.
      #
      # @return [Array<Integer>]
      #   The ranks of the results which match the given block.
      #
      # @example
      #   page.ranks_of { |result| result.title =~ /awesome/ }
      #
      def ranks_of(&block)
        results_with(&block).ranks
      end

      #
      # Returns the titles of the results that match the given block.
      #
      # @yield [result]
      #   The given block will be used to filter the results in the page.
      #
      # @yieldparam [Result] result
      #   A result in the page.
      #
      # @return [Array<String>]
      #   The titles of the results which match the given block.
      #
      # @example
      #   page.titles_of { |result| result.url.include?('www') }
      #
      def titles_of(&block)
        results_with(&block).titles
      end

      #
      # Returns the URLs of the results that match the given block.
      #
      # @yield [result]
      #   The given block will be used to filter the results in the page.
      #
      # @yieldparam [Result] result
      #   A result in the page.
      #
      # @return [Array<URI::HTTP>]
      #   The URLs of the results which match the given block.
      #
      # @example
      #   page.urls_of { |result| result.summary =~ /awesome pants/ }
      #
      def urls_of(&block)
        results_with(&block).urls
      end

      #
      # Returns the summaries of the results that match the given block.
      #
      # @yield [result]
      #   The given block will be used to filter the results in the page.
      #
      # @yieldparam [Result] result
      #   A result in the page.
      #
      # @return [Array<String>]
      #   The summaries of the results which match the given block.
      #
      # @example
      #   page.summaries_of { |result| result.title =~ /what if/ }
      #
      def summaries_of(&block)
        results_with(&block).summaries
      end

      #
      # Returns the Cached URLs of the results that match the given block.
      #
      # @yield [result]
      #   The given block will be used to filter the results in the page.
      #
      # @yieldparam [Result] result
      #   A result in the page.
      #
      # @return [Array<URI::HTTP>]
      #   The Cached URLs of the results which match the given block.
      #
      # @example
      #   page.cached_urls_of { |result| result.title =~ /howdy/ }
      #
      def cached_urls_of(&block)
        results_with(&block).cached_urls
      end

      #
      # Returns the cached pages of the results that match the given block.
      #
      # @yield [result]
      #   The given block will be used to filter the results in the page.
      #
      # @yieldparam [Result] result
      #   A result in the page.
      #
      # @return [Array<Mechanize::Page>]
      #   The Cached Page of the results which match the given block.
      #
      # @example
      #   page.cached_pages_of { |result| result.title =~ /dude/ }
      #
      def cached_pages_of(&block)
        results_with(&block).cached_pages
      end

      #
      # Returns the Similar Query URLs of the results that match the given
      # block.
      #
      # @yield [result]
      #   The given block will be used to filter the results in the page.
      #
      # @yieldparam [Result] result
      #   A result in the page.
      #
      # @return [Array<URI::HTTP>]
      #   The Similar Query URLs of the results which match the given block.
      #
      # @example
      #   page.similar_urls_of { |result| result.title =~ /what if/ }
      #
      def similar_urls_of(&block)
        results_with(&block).similar_urls
      end

    end
  end
end
