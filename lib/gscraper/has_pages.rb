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

module GScraper
  module HasPages
    include Enumerable

    #
    # Returns the first page.
    #
    def first_page
      page_cache[1]
    end

    #
    # Returns the page at the specified _index_.
    #
    def [](index)
      page_cache[index]
    end

    #
    # Returns the pages with the specified _indices_.
    #
    def pages(indices)
      indices.map { |index| page_cache[index] }
    end

    #
    # Iterates over the pages with the specified _indices_, passing each
    # to the specified _block_.
    #
    def each_page(indices,&block)
      indices.map { |index| block.call(page_cache[index]) }
    end

    #
    # Iterates over all the pages of the query, passing each to the
    # specified _block_.
    #
    def each(&block)
      index = 1

      until ((next_page = page_cache[index]).empty?) do
        block.call(next_page)
        index = index + 1
      end

      return self
    end

    #
    # Iterates over the elements on the page with the specified _index_,
    # passing each element to the specified _block_.
    #
    def each_on_page(index,&block)
      page_cache[index].each(&block)
    end

    #
    # Iterates over each element on the pages with the specified _indices_,
    # passing each element to the specified _block_.
    #
    def each_on_pages(indices,&block)
      each_page(indices) { |page| page.each(&block) }
    end

    protected

    #
    # Returns the page index for the specified result _rank_.
    #
    def page_index_of(rank)
      (((rank.to_i - 1) / results_per_page.to_i) + 1)
    end

    #
    # Returns the rank offset for the specified _page_index_.
    #
    def result_offset_of(page_index)
      ((page_index.to_i - 1) * results_per_page.to_i)
    end

    #
    # Returns the in-page index of the specified result _rank_.
    #
    def result_index_of(rank)
      ((rank.to_i - 1) % results_per_page.to_i)
    end

    #
    # The cache of previously requested pages.
    #
    def page_cache
      @page_cache ||= Hash.new { |hash,key| hash[key] = page(key.to_i) }
    end
  end
end
