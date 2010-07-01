#
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
#

require 'uri/http'
require 'mechanize'
require 'nokogiri'
require 'open-uri'

module GScraper
  # Common proxy port.
  COMMON_PROXY_PORT = 8080

  #
  # The proxy information.
  #
  # @return [Hash]
  #
  def GScraper.proxy
    @@gscraper_proxy ||= {:host => nil, :port => COMMON_PROXY_PORT, :user => nil, :password => nil}
  end

  #
  # Creates a HTTP URI for the current proxy.
  #
  # @param [Hash] proxy_info
  #   The proxy information.
  #
  # @option proxy_info [String] :host
  #   The proxy host.
  #
  # @option proxy_info [Integer] :port (COMMON_PROXY_PORT)
  #   The proxy port.
  #
  # @option proxy_info [String] :user
  #   The user-name to login as.
  #
  # @option proxy_info [String] :password
  #   The password to login with.
  #
  def GScraper.proxy_uri(proxy_info=GScraper.proxy)
    if GScraper.proxy[:host]
      return URI::HTTP.build(
        :host => GScraper.proxy[:host],
        :port => GScraper.proxy[:port],
        :userinfo => "#{GScraper.proxy[:user]}:#{GScraper.proxy[:password]}",
        :path => '/'
      )
    end
  end
  
  #
  # The supported GScraper User-Agent Aliases.
  #
  # @return [Array<String>]
  #
  def GScraper.user_agent_aliases
    Mechanize::AGENT_ALIASES
  end

  #
  # The GScraper User-Agent.
  #
  # @return [String]
  #
  def GScraper.user_agent
    @@gscraper_user_agent ||= GScraper.user_agent_aliases['Windows IE 6']
  end

  #
  # Sets the GScraper User-Agent.
  #
  # @param [String] agent
  #   The new User-Agent string.
  #
  # @return [String]
  #   The new User-Agent string.
  #
  def GScraper.user_agent=(agent)
    @@gscraper_user_agent = agent
  end

  #
  # Sets the GScraper User-Agent.
  #
  # @param [String] name
  #   The User-Agent alias.
  #
  # @return [String]
  #   The new User-Agent string.
  # 
  def GScraper.user_agent_alias=(name)
    @@gscraper_user_agent = GScraper.user_agent_aliases[name.to_s]
  end

  #
  # Creates a new Mechanize agent.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [String] :user_agent_alias
  #   The User-Agent Alias to use.
  #
  # @option options [String] :user_agent
  #   The User-Agent string to use.
  #
  # @option options [Hash] :proxy
  #   The proxy information to use.
  #
  # @option :proxy [String] :host
  #   The proxy host.
  #
  # @option :proxy [Integer] :port
  #   The proxy port.
  #
  # @option :proxy [String] :user
  #   The user-name to login as.
  #
  # @option :proxy [String] :password
  #   The password to login with.
  #
  # @example
  #   GScraper.web_agent
  #
  # @example
  #   GScraper.web_agent(:user_agent_alias => 'Linux Mozilla')
  #   GScraper.web_agent(:user_agent => 'Google Bot')
  #
  def GScraper.web_agent(options={})
    agent = Mechanize.new

    if options[:user_agent_alias]
      agent.user_agent_alias = options[:user_agent_alias]
    elsif options[:user_agent]
      agent.user_agent = options[:user_agent]
    elsif GScraper.user_agent
      agent.user_agent = GScraper.user_agent
    end

    proxy = (options[:proxy] || GScraper.proxy)
    if proxy[:host]
      agent.set_proxy(proxy[:host],proxy[:port],proxy[:user],proxy[:password])
    end

    yield agent if block_given?
    return agent
  end
end
