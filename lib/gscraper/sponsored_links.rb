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

require 'gscraper/sponsored_ad'

require 'enumerator'

module GScraper
  class SponsoredLinks < Array
    #
    # Creates a new SponsoredLinks object with the given _ads_. If a
    # _block_ is given, it will be passed the newly created SponsoredLinks
    # object.
    #
    def initialize(ads=[])
      super(ads)

      yield self if block_given?
    end

    #
    # Returns a mapped Array of the ads within the SponsoredLinks
    # using the given _block_. If the _block_ is not given, the
    # SponsoredLinks will be returned.
    #
    #   sponsored.map # => SponsoredLinks
    #
    #   sponsored.map { |ad| ad.url } # => [...]
    #
    def map
      return enum_for(:map) unless block_given?

      mapped = []

      each { |ad| mapped << yield(ad) }
      return mapped
    end

    #
    # Selects the ads within the SponsoredLinks which match the given _block_.
    #
    #   sponsored.select { |ad| ad.title =~ /consume/i }
    #
    def select(&block)
      unless block
        enum_for(:select)
      else
        SponsoredLinks.new(super(&block))
      end
    end

    alias ads_with select

    #
    # Selects the ads with the matching _title_. The _title_ may be
    # either a String or a Regexp. If _block_ is given, each matching
    # ad will be passed to the _block_.
    #
    #   sponsored.ads_with_title('be attractive') #=> SponsoredLinks
    #
    #   sponsored.ads_with_title(/buy me/) do |ad|
    #     puts ad.url
    #   end
    #
    def ads_with_title(title)
      return enum_for(:ads_with_title,title) unless block_given?

      comparitor = if title.kind_of?(Regexp)
                     lambda { |ad| ad.title =~ title }
                   else
                     lambda { |ad| ad.title == title }
                   end

      return ads_with do |ad|
        if comparitor.call(ad)
          yield ad

          true
        end
      end
    end

    #
    # Selects the ads with the matching _url_. The _url_ may be
    # either a String or a Regexp. If _block_ is given, each matching
    # ad will be passed to the _block_.
    #
    #   sponsored.ads_with_url(/\.com/) # => SponsoredLinks
    #
    def ads_with_url(url)
      return enum_for(:ads_with_url,url) unless block_given?

      comparitor = if url.kind_of?(Regexp)
                     lambda { |ad| ad.url =~ url }
                   else
                     lambda { |ad| ad.url == url }
                   end

      return ads_with do |ad|
        if comparitor.call(ad)
          yield ad

          true
        end
      end
    end

    #
    # Selects the ads with the matching _direct_url_. The _direct_url_ may
    # be either a String or a Regexp. If _block_ is given, each matching
    # ad will be passed to the _block_.
    #
    #   sponsored.ads_with_direct_url(/\.com/) # => SponsoredLinks
    #
    def ads_with_direct_url(direct_url)
      return enum_for(:ads_with_direct_url,direct_url) unless block_given?

      comparitor = if direct_url.kind_of?(Regexp)
                     lambda { |ad| ad.direct_url =~ direct_url }
                   else
                     lambda { |ad| ad.direct_url == direct_url }
                   end

      return ads_with do |ad|
        if comparitor.call(ad)
          yield ad

          true
        end
      end
    end

    #
    # Iterates over each ad's title within the SponsoredLinks, passing
    # each to the given _block_.
    #
    #   each_title { |title| puts title }
    #
    def each_title
      unless block_given?
        enum_for(:each_title)
      else
        each { |ad| yield ad.title }
      end
    end

    #
    # Iterates over each ad's URL within the SponsoredLinks, passing each to
    # the given _block_.
    #
    #   each_url { |url| puts url }
    #
    def each_url
      unless block_given?
        enum_for(:each_url)
      else
        each { |ad| yield ad.url }
      end
    end

    #
    # Iterates over each ad's direct URL within the SponsoredLinks, passing
    # each to the given _block_.
    #
    #   each_direct_url { |url| puts url }
    #
    def each_direct_url
      unless block_given?
        enum_for(:each_direct_url)
      else
        each { |ad| yield ad.direct_url }
      end
    end

    #
    # Returns an Array containing the titles of the ads within the
    # SponsoredLinks.
    #
    #   sponsored.titles # => [...]
    #
    def titles
      each_title.to_a
    end

    #
    # Returns an Array containing the URLs of the ads within the
    # SponsoredLinks.
    #
    #   sponsored.urls # => [...]
    #
    def urls
      each_url.to_a
    end

    #
    # Returns an Array containing the direct URLs of the ads within the
    # SponsoredLinks.
    #
    #   sponsored.direct_urls # => [...]
    #
    def direct_urls
      each_direct_url.to_a
    end

    #
    # Returns the titles of the ads that match the specified _block_.
    #
    #   sponsored.titles_of { |ad| ad.url.include?('www') }
    #
    def titles_of(&block)
      ads_with(&block).titles
    end

    #
    # Returns the URLs of the ads that match the specified _block_.
    #
    #   sponsored.urls_of { |ad| ad.title =~ /buy these pants/ }
    #
    def urls_of(&block)
      ads_with(&block).urls
    end

    #
    # Returns the direct URLs of the ads that match the specified _block_.
    #
    #   sponsored.urls_of { |ad| ad.title =~ /buy these pants/ }
    #
    def direct_urls_of(&block)
      ads_with(&block).direct_urls
    end

  end
end
