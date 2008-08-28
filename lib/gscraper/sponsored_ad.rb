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

require 'gscraper/extensions/uri'

module GScraper
  class SponsoredAd

    # Title of the ad
    attr_reader :title

    # URL of the ad
    attr_reader :url

    #
    # Creates a new SponsoredAd with the specified _title_ and _url_.
    #
    def initialize(title,url)
      @title = title
      @url = url
    end

    #
    # Returns the direct URL of the ad.
    #
    def direct_url
      URI(@url.query_params['adurl'] || @url.query_params['q'])
    end

    #
    # Returns the title of the ad.
    #
    def to_s
      @title.to_s
    end

  end
end
