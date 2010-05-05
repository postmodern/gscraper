#
#--
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
#++
#

require 'gscraper/search/result'
require 'gscraper/page'

module GScraper
  module Search
    class Page < GScraper::Page

      alias results_with select

      #
      # Selects the results with the matching _title_. The _title_ may be
      # either a String or a Regexp. If _block_ is given, each matching
      # result will be passed to the _block_.
      #
      #   page.results_with_title('hackety org') #=> Page
      #
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
      # Selects the results with the matching _url_. The _url_ may be
      # either a String or a Regexp. If _block_ is given, each matching
      # result will be passed to the _block_.
      #
      #   page.results_with_url(/\.com/) # => Page
      #
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
      # Selects the results with the matching _summary_. The _summary_ may
      # be either a String or a Regexp. If _block_ is given, each matching
      # result will be passed to the _block_.
      #
      #   page.results_with_summary(/cheese cake/) # => Page
      #
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
      # Iterates over each result's rank within the Page, passing each to
      # the given _block_.
      #
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
      # Iterates over each result's title within the Page, passing each to
      # the given _block_.
      #
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
      # Iterates over each result's url within the Page, passing each to
      # the given _block_.
      #
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
      # Iterates over each result's summary within the Page, passing each
      # to the given _block_.
      #
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
      # Iterates over each result's cached URLs within the Page, passing
      # each to the given _block_.
      #
      #   each_cached_url { |url| puts url }
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
      # Iterates over each result's cached pages within the Page, passing
      # each to the given _block_.
      #
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
      # Iterates over each result's similar Query URLs within the Page,
      # passing each to the given _block_.
      #
      #   each_similar_url { |url| puts url }
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
      # Returns an Array containing the ranks of the results within the
      # Page.
      #
      #   page.ranks # => [...]
      #
      def ranks
        each_rank.to_a
      end

      #
      # Returns an Array containing the titles of the results within the
      # Page.
      #
      #   page.titles # => [...]
      #
      def titles
        each_title.to_a
      end

      #
      # Returns an Array containing the URLs of the results within the
      # Page.
      #
      #   page.urls # => [...]
      #
      def urls
        each_url.to_a
      end

      #
      # Returns an Array containing the summaries of the results within the
      # Page.
      #
      #   page.summaries # => [...]
      #
      def summaries
        each_summary.to_a
      end

      #
      # Returns an Array containing the cached URLs of the results within
      # the Page.
      #
      #   page.cached_urls # => [...]
      #
      def cached_urls
        each_cached_url.to_a
      end

      #
      # Returns an Array containing the cached pages of the results within
      # the Page.
      #
      #   page.cached_pages # => [...]
      #
      def cached_pages
        each_cached_page.to_a
      end

      #
      # Returns an Array containing the similar Query URLs of the results
      # within the Page.
      #
      #   page.similar_urls # => [...]
      #
      def similar_urls
        each_similar_url.to_a
      end

      #
      # Returns the ranks of the results that match the specified _block_.
      #
      #   page.ranks_of { |result| result.title =~ /awesome/ }
      #
      def ranks_of(&block)
        results_with(&block).ranks
      end

      #
      # Returns the titles of the results that match the specified _block_.
      #
      #   page.titles_of { |result| result.url.include?('www') }
      #
      def titles_of(&block)
        results_with(&block).titles
      end

      #
      # Returns the urls of the results that match the specified _block_.
      #
      #   page.urls_of { |result| result.summary =~ /awesome pants/ }
      #
      def urls_of(&block)
        results_with(&block).urls
      end

      #
      # Returns the summaries of the results that match the specified
      # _block_.
      #
      #   page.summaries_of { |result| result.title =~ /what if/ }
      #
      def summaries_of(&block)
        results_with(&block).summaries
      end

      #
      # Returns the cached URLs of the results that match the specified
      # _block_.
      #
      #   page.cached_urls_of { |result| result.title =~ /howdy/ }
      #
      def cached_urls_of(&block)
        results_with(&block).cached_urls
      end

      #
      # Returns the cached pages of the results that match the specified
      # _block_. If _options_ are given, they will be used in accessing
      # the cached pages.
      #
      #   page.cached_pages_of { |result| result.title =~ /dude/ }
      #
      def cached_pages_of(options={},&block)
        results_with(&block).cached_pages(options)
      end

      #
      # Returns the similar query URLs of the results that match the
      # specified _block_.
      #
      #   page.similar_urls_of { |result| result.title =~ /what if/ }
      #
      def similar_urls_of(&block)
        results_with(&block).similar_urls
      end

    end
  end
end
