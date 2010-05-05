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

module GScraper
  class Page < Array

    #
    # Creates a new Page object with the given _elements_. If a _block_
    # is given, it will be passed the newly created Page object.
    #
    def initialize(elements=[])
      super(elements)

      yield self if block_given?
    end

    #
    # Returns a mapped Array of the elements within the Page using the
    # given _block_. If the _block_ is not given, the page will be
    # returned.
    #
    #   page.map # => Page
    #
    #   page.map { |element| element.field } # => [...]
    #
    def map
      return self unless block_given?

      mapped = []

      each { |element| mapped << yield(element) }
      return mapped
    end

    #
    # Selects the elements within the Page which match the given _block_.
    #
    #   page.select { |element| element.field =~ /ruby/i }
    #
    def select(&block)
      self.class.new(super(&block))
    end

  end
end
