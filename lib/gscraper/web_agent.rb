require 'gscraper/gscraper'

require 'mechanize'

module GScraper
  module WebAgent
    #
    # Creates a new Mechanize agent with the given _options_.
    #
    # _options_ may contain the following keys:
    # <tt>:user_agent_alias</tt>:: The user-agent-alias the +web_agent+
    #                              will use.
    # <tt>:user_agent</tt>:: The user-agent-string the +web_agent+ will
    #                        use.
    # <tt>:proxy</tt>:: The proxy +Hash+ that the +web_agent+ will use.
    #
    def initialize(options={})
      @web_agent = WWW::Mechanize.new()

      if options[:user_agent_alias]
        self.user_agent_alias = options[:user_agent_alias]
      elsif options[:user_agent]
        self.user_agent = options[:user_agent]
      elsif GScraper.user_agent
        self.user_agent = GScraper.user_agent
      end

      proxy = (options[:proxy] || GScraper.proxy)
      self.set_proxy(proxy) if proxy[:host]
    end

    #
    # Returns the +web_agent+s user-agent-string.
    #
    def user_agent
      @web_agent.user_agent
    end

    #
    # Sets the +web_agent+s user-agent-string to the specified _string_.
    #
    def user_agent=(string)
      @web_agent.user_agent = string
    end

    #
    # Returns the +web_agent+s user-agent-alias.
    #
    def user_agent_alias
      @web_agent.user_agent
    end

    #
    # Sets the +web_agent+s user-agent-alias to the specified _name_.
    #
    def user_agent_alias=(name)
      @web_agent.user_agent_alias = name
    end

    #
    # Sets the proxy of the current +web_agent+ using the specified
    # _options_.
    #
    # _options_ most contain the following key:
    # <tt>:host</tt>:: The Proxy host.
    #
    # _options_ may contain the following keys:
    # <tt>:port</tt>:: The Proxy port, defaults to DEFAULT_PROXY_PORT.
    # <tt>:user</tt>:: The user to use with the Proxy.
    # <tt>:pass</tt>:: The password of the user.
    #
    def set_proxy(options={})
      host = options[:host]
      port = (options[:port] || GScraper::COMMON_PROXY_PORT)
      user = options[:user]
      pass = options[:pass]

      @web_agent.set_proxy(host,port,user,pass)
      return self
    end

    protected

    #
    # Fetches the specified _url_, with the given _referer_ using the
    # +web_agent_+.
    #
    #   get_page('http://www.hackety.org/')
    #
    def get_page(url,referer=nil,&block)
      @web_agent.get(url,referer,&block)
    end

    #
    # Posts the specified _url_ and the given _query_ parameters using the
    # +web_agent+.
    #
    #   post_page('http://www.wired.com/', :q => 'the future')
    #
    def post_page(url,query={})
      @web_agent.post(url,query)
    end

  end
end
