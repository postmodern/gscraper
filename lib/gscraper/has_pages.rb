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

require 'enumerator'

module GScraper
  module HasPages
    include Enumerable

    #
    # The first page.
    #
    # @return [Page]
    #   The first page.
    #
    def first_page
      page_cache[1]
    end

    #
    # The page at the specified index.
    #
    # @param [Integer] index
    #   The index.
    #
    # @return [Page]
    #   The page at the given index.
    #
    def [](index)
      page_cache[index]
    end

    #
    # The pages with the specified indices.
    #
    # @param [Array, Range] indices
    #   The indices.
    #
    # @return [Page]
    #   The pages at the given indices.
    #
    def pages(indices)
      indices.map { |index| page_cache[index] }
    end

    #
    # Iterates over the pages at the specified indices.
    #
    # @param [Array, Range] indices
    #   The indices.
    #
    # @yield [page]
    #   The given block will be passed each page.
    #
    # @yieldparam [Page] page
    #   A page at one of the given indices.
    #
    def each_page(indices)
      unless block_given?
        enum_for(:each_page,indices)
      else
        indices.map { |index| yield page_cache[index] }
      end
    end

    #
    # Iterates over all the pages of the query, until an empty page is
    # encountered.
    #
    # @yield [page]
    #   A page with results from the query.
    #
    # @yieldparam [Page] page
    #   A non-empty page from the query.
    #
    def each
      return enum_for(:each) unless block_given?

      index = 1

      until ((next_page = page_cache[index]).empty?) do
        yield next_page
        index = index + 1
      end

      return self
    end

    #
    # Iterates over the elements on the page with the specified index.
    #
    # @param [Integer] index
    #   The index to access.
    #
    def each_on_page(index,&block)
      page_cache[index].each(&block)
    end

    #
    # Iterates over each element on the pages with the specified indices.
    #
    # @param [Array, Range] indices
    #   The indices to access.
    #
    def each_on_pages(indices,&block)
      each_page(indices) { |page| page.each(&block) }
    end

    protected

    #
    # The page index for the specified result rank.
    #
    # @param [Integer] rank
    #   A result ranking.
    #
    # @return [Integer]
    #   The page index.
    #
    def page_index_of(rank)
      (((rank.to_i - 1) / results_per_page.to_i) + 1)
    end

    #
    # The rank offset for the specified page-index.
    #
    # @param [Integer] page_index
    #   The result offset within a page.
    #
    def result_offset_of(page_index)
      ((page_index.to_i - 1) * results_per_page.to_i)
    end

    #
    # The in-page index of the specified result rank.
    #
    # @param [Integer] rank
    #   The result ranking.
    #
    # @return [Integer]
    #   The in-page index.
    #
    def result_index_of(rank)
      ((rank.to_i - 1) % results_per_page.to_i)
    end

    #
    # The cache of previously requested pages.
    #
    # @return [Hash]
    #
    def page_cache
      @page_cache ||= Hash.new { |hash,key| hash[key] = page(key.to_i) }
    end
  end
end
