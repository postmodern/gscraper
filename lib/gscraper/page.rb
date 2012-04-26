#
# GScraper - A web-scraping interface to various Google Services.
#
# Copyright (c) 2007-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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
  class Page < Array

    #
    # Creates a new Page object.
    #
    # @param [Array] elements
    #   The elements to populate the page with.
    #
    # @yield [page]
    #   If a block is given, it will be passed the newly created page.
    #
    # @yieldparam [Page] page
    #   The newly created page.
    #
    def initialize(elements=[])
      super(elements)

      yield self if block_given?
    end

    #
    # Maps the elements within the page.
    #
    # @yield [element]
    #   The given block will be passed each element in the page.
    #
    # @return [Array, Enumerator]
    #   The mapped result. If no block was given, an Enumerator object will
    #   be returned.
    #
    # @example
    #   page.map
    #   # => Page
    #
    # @example
    #   page.map { |element| element.field }
    #   # => [...]
    #
    def map
      return enum_for(:map) unless block_given?

      mapped = []

      each { |element| mapped << yield(element) }
      return mapped
    end

    #
    # Selects the elements within the page.
    #
    # @yield [element]
    #   The given block will be passed each element in the page.
    #
    # @return [Array, Enumerator]
    #   The selected elements. If no block was given, an Enumerator object
    #   is returned.
    #
    # @example
    #   page.select { |element| element.field =~ /ruby/i }
    #
    def select(&block)
      unless block
        enum_for(:select)
      else
        self.class.new(super(&block))
      end
    end

  end
end
