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
      @url = URI.parse(url)
    end

    #
    # Returns the direct URL of the ad.
    #
    def direct_url
      @url.query_params['adurl'] || @url.query_params['q']
    end

    #
    # Returns the title of the ad.
    #
    def to_s
      @title.to_s
    end

  end
end
