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
