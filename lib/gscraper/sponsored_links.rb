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

require 'gscraper/sponsored_ad'

require 'enumerator'

module GScraper
  class SponsoredLinks < Array

    #
    # Creates a new SponsoredLinks object.
    #
    # @param [Array] ads
    #   The ads to populate the sponsored links object with.
    #
    # @yield [links]
    #   If a block is given, it will be passed the new sponsored links
    #   object.
    #
    # @yieldparam [SponsoredLinks] links
    #   The new sponsored links object.
    #
    def initialize(ads=[])
      super(ads)

      yield self if block_given?
    end

    #
    # Maps the sponsored ads.
    #
    # @yield [ad]
    #   The given block will be passed each ad.
    #
    # @yieldparam [SponsoredAd] ad
    #   The sponsored ad.
    #
    # @return [Array, Enumerator]
    #   The mapped result. If no block was given, an Enumerator object will
    #   be returned.
    #
    # @example
    #   sponsored.map
    #   # => SponsoredLinks
    #
    # @example
    #   sponsored.map { |ad| ad.url }
    #   # => [...]
    #
    def map
      return enum_for(:map) unless block_given?

      mapped = []

      each { |ad| mapped << yield(ad) }
      return mapped
    end

    #
    # Selects the ads within the sponsored links.
    #
    # @yield [ad]
    #   The given block will determine which ads to select.
    #
    # @yieldparam [SponsoredAd] ad
    #   A sponsored ad.
    #
    # @return [Array, Enumerator]
    #   The selected ads. If no block is given, an Enumerator object will
    #   be returned.
    #
    # @example
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
    # Selects the ads with the matching title.
    #
    # @param [String, Regexp] title
    #   The title to search for.
    #
    # @yield [ad]
    #   Each matching ad will be passed to the given block.
    #
    # @yieldparam [SponsoredAd] ad
    #   A sponsored ad with the matching title.
    #
    # @return [Array, Enumerator]
    #   The sponsored ads with the matching title. If no block is given,
    #   an Enumerator object will be returned.
    #
    # @example
    #   sponsored.ads_with_title('be attractive')
    #   # => SponsoredLinks
    #
    # @example
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
    # Selects the ads with the matching URL.
    #
    # @param [String, Regexp] url
    #   The URL to search for.
    #
    # @yield [ad]
    #   Each matching ad will be passed to the given block.
    #
    # @yieldparam [SponsoredAd] ad
    #   A sponsored ad with the matching URL.
    #
    # @return [Array, Enumerator]
    #   The sponsored ads with the matching URL. If no block is given,
    #   an Enumerator object will be returned.
    #
    # @example
    #   sponsored.ads_with_url(/\.com/)
    #   # => SponsoredLinks
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
    # Selects the ads with the matching direct URL.
    #
    # @param [String, Regexp] direct_url
    #   The direct URL to search for.
    #
    # @yield [ad]
    #   Each matching ad will be passed to the given block.
    #
    # @yieldparam [SponsoredAd] ad
    #   A sponsored ad with the matching direct URL.
    #
    # @return [Array, Enumerator]
    #   The sponsored ads with the matching URL. If no block is given,
    #   an Enumerator object will be returned.
    #
    # @example
    #   sponsored.ads_with_direct_url(/\.com/)
    #   # => SponsoredLinks
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
    # Iterates over the titles of each ad.
    #
    # @yield [title]
    #   The given block will be passed each title.
    #
    # @yieldparam [String] title
    #   A title of an ad.
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
        each { |ad| yield ad.title }
      end
    end

    #
    # Iterates over the URLs of each ad.
    #
    # @yield [url]
    #   The given block will be passed each URL.
    #
    # @yieldparam [URI::HTTP] url
    #   An URL of an ad.
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
        each { |ad| yield ad.url }
      end
    end

    #
    # Iterates over the direct URLs of each ad.
    #
    # @yield [direct_url]
    #   The given block will be passed each direct URL.
    #
    # @yieldparam [URI::HTTP] direct_url
    #   A direct URL of an ad.
    #
    # @return [Enumerator]
    #   If no block is given, an Enumerator object will be returned.
    #
    # @example
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
    # The titles for the ads.
    #
    # @return [Array<String>]
    #   The titles for the ads.
    #
    # @example
    #   sponsored.titles # => [...]
    #
    def titles
      each_title.to_a
    end

    #
    # The URLs for the ads.
    #
    # @return [Array<URI::HTTP>]
    #   The URLs for the ads.
    #
    # @example
    #   sponsored.urls # => [...]
    #
    def urls
      each_url.to_a
    end

    #
    # The direct URLs for the ads.
    #
    # @return [Array<URI::HTTP>]
    #   The direct URLs for the ads.
    #
    # @example
    #   sponsored.direct_urls # => [...]
    #
    def direct_urls
      each_direct_url.to_a
    end

    #
    # The titles of the selected ads.
    #
    # @yield [ad]
    #   The given block will be passed each ad to be selected.
    #
    # @yieldparam [SponsoredAd] ad
    #   An ad to be selected.
    #
    # @return [Array<String>]
    #   The titles of the selected ads.
    #
    # @example
    #   sponsored.titles_of { |ad| ad.url.include?('www') }
    #
    def titles_of(&block)
      ads_with(&block).titles
    end

    #
    # The URLs of the selected ads.
    #
    # @yield [ad]
    #   The given block will be passed each ad to be selected.
    #
    # @yieldparam [SponsoredAd] ad
    #   An ad to be selected.
    #
    # @return [Array<String>]
    #   The URLs of the selected ads.
    #
    # @example
    #   sponsored.urls_of { |ad| ad.title =~ /buy these pants/ }
    #
    def urls_of(&block)
      ads_with(&block).urls
    end

    #
    # The direct URLs of the selected ads.
    #
    # @yield [ad]
    #   The given block will be passed each ad to be selected.
    #
    # @yieldparam [SponsoredAd] ad
    #   An ad to be selected.
    #
    # @return [Array<String>]
    #   The direct URLs of the selected ads.
    #
    # @example
    #   sponsored.urls_of { |ad| ad.title =~ /buy these pants/ }
    #
    def direct_urls_of(&block)
      ads_with(&block).direct_urls
    end

  end
end
