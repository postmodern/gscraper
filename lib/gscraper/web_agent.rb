require 'gscraper/gscraper'

module GScraper
  module WebAgent
    protected

    #
    # Returns the WWW::Mechanize agent.
    #
    def web_agent(&block)
      @web_agent ||= GScraper.web_agent

      block.call(@web_agent) if block
      return @web_agent
    end

    #
    # Fetches the specified _url_, with the given _referer_ using the
    # web_agent.
    #
    #   get_page('http://www.hackety.org/')
    #
    def get_page(url,referer=nil,&block)
      web_agent.get(url,referer,&block)
    end

    #
    # Posts the specified _url_ and the given _query_ parameters using the
    # web_agent.
    #
    #   post_page('http://www.wired.com/', :q => 'the future')
    #
    def post_page(url,query={})
      web_agent.post(url,query)
    end

  end
end
