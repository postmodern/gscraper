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

require 'gscraper/sponsored_ad'

module GScraper
  class SponsoredLinks < Array
    #
    # Creates a new SponsoredLinks object with the given _ads_. If a
    # _block_ is given, it will be passed the newly created SponsoredLinks
    # object.
    #
    def initialize(ads=[],&block)
      super(ads)

      block.call(self) if block
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
    def map(&block)
      return self unless block

      mapped = []

      each { |ad| mapped << block.call(ad) }
      return mapped
    end

    #
    # Selects the ads within the SponsoredLinks which match the given _block_.
    #
    #   sponsored.select { |ad| ad.title =~ /consume/i }
    #
    def select(&block)
      SponsoredLinks.new(super(&block))
    end

    #
    # Selects the ads using the specified _block_.
    #
    #   sponsored.ads_with { |ad| ad.title =~ /status symbol/ }
    #
    def ads_with(&block)
      select(&block)
    end

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
    def ads_with_title(title,&block)
      if title.kind_of?(Regexp)
        ads = ads_with { |ad| ad.title =~ title }
      else
        ads = ads_with { |ad| ad.title == title }
      end

      ads.each(&block) if block
      return ads
    end

    #
    # Selects the ads with the matching _url_. The _url_ may be
    # either a String or a Regexp. If _block_ is given, each matching
    # ad will be passed to the _block_.
    #
    #   sponsored.ads_with_url(/\.com/) # => SponsoredLinks
    #
    #   sponsored.ads_with_url(/^https:\/\//) do |ad|
    #     puts ad.title
    #   end
    #
    def ads_with_url(url,&block)
      if url.kind_of?(Regexp)
        ads = ads_with { |ad| ad.url =~ url }
      else
        ads = ads_with { |ad| ad.url == url }
      end

      ads.each(&block) if block
      return ads
    end

    #
    # Returns an Array containing the titles of the ads within the
    # SponsoredLinks.
    #
    #   sponsored.titles # => [...]
    #
    def titles
      map { |ad| ad.title }
    end

    #
    # Returns an Array containing the URLs of the ads within the
    # SponsoredLinks.
    #
    #   sponsored.urls # => [...]
    #
    def urls
      map { |ad| ad.url }
    end

    #
    # Iterates over each ad's title within the SponsoredLinks, passing each to
    # the given _block_.
    #
    #   each_title { |title| puts title }
    #
    def each_title(&block)
      titles.each(&block)
    end

    #
    # Iterates over each ad's url within the SponsoredLinks, passing each to
    # the given _block_.
    #
    #   each_url { |url| puts url }
    #
    def each_url(&block)
      urls.each(&block)
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
    # Returns the urls of the ads that match the specified _block_.
    #
    #   sponsored.urls_of { |ad| ad.title =~ /buy these pants/ }
    #
    def urls_of(&block)
      ads_with(&block).urls
    end

  end
end
