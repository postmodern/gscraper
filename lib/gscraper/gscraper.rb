require 'mechanize'
require 'open-uri'

module GScraper
  #
  # Returns the supported GScraper User-Agent Aliases.
  #
  def GScraper.user_agent_aliases
    WWW::Mechanize::AGENT_ALIASES
  end

  #
  # Returns the GScraper User-Agent
  #
  def GScraper.user_agent
    @user_agent ||= nil
  end

  #
  # Sets the GScraper User-Agent to the specified _agent_.
  #
  def GScraper.user_agent=(agent)
    @user_agent = agent
  end

  #
  # Opens the _uri_ with the given _opts_. The contents of the _uri_ will be
  # returned.
  #
  #   GScraper.open('http://www.hackety.org/')
  #
  #   GScraper.open('http://tenderlovemaking.com/',
  #     :user_agent_alias => 'Linux Mozilla')
  #   GScraper.open('http://www.wired.com/', :user_agent => 'the future')
  #
  def GScraper.open(uri,opts={})
    headers = {}

    if opts[:user_agent_alias]
      headers['User-Agent'] = WWW::Mechanize::AGENT_ALIASES[opts[:user_agent_alias]]
    elsif opts[:user_agent]
      headers['User-Agent'] = opts[:user_agent]
    elsif GScraper.user_agent
      headers['User-Agent'] = GScraper.user_agent
    end

    return Kernel.open(uri,headers)
  end

  #
  # Creates a new Mechanize agent with the given _opts_.
  #
  #   GScraper.web_agent
  #   GScraper.web_agent(:user_agent_alias => 'Linux Mozilla')
  #   GScraper.web_agent(:user_agent => 'wooden pants')
  #
  def GScraper.web_agent(opts={})
    agent = WWW::Mechanize.new

    if opts[:user_agent_alias]
      agent.user_agent_alias = opts[:user_agent_alias]
    elsif opts[:user_agent]
      agent.user_agent = opts[:user_agent]
    elsif GScraper.user_agent
      agent.user_agent = GScraper.user_agent
    end

    return agent
  end
end
