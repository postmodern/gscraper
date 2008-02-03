require 'mechanize'

module GScraper
  # Common proxy port.
  COMMON_PROXY_PORT = 8080

  #
  # Returns the +Hash+ of proxy information.
  #
  def GScraper.proxy
    @@proxy ||= {:host => nil, :port => COMMON_PROXY_PORT, :user => nil, :pass => nil}
  end

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
    @@user_agent ||= GScraper.user_agent_aliases['Windows IE 6']
  end

  #
  # Sets the GScraper User-Agent to the specified _agent_.
  #
  def GScraper.user_agent=(agent)
    @@user_agent = agent
  end
end
